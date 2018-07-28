module Spree::Search
  class Searchkick < Spree::Core::Search::Base
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      # Sample configurable_attribute
      attr_accessor :configurable_attribute

      def initialize
        @configurable_attribute = false
      end
    end

    def retrieve_products
      @products = get_base_search
    end

    protected

    def get_base_search
      # If a query is passed in, then we are only using the ElasticSearch DSL and don't care about any other options
      query = @properties[:query]
      if query
        Spree::Product.search(query: query)
      else
        search_options = {
          # Set execute to false in case we need to modify the search before it is executed
          execute: false,

          where:    where_clause,
          page:     @properties[:page],
          per_page: @properties[:per_page],
        }

        fields = @properties[:fields]
        search_options.merge!(fields: fields) if fields
        search_options.merge!(@properties[:searchkick_options])
        search_options.deep_merge!(includes: includes_clause)

        keywords = @properties[:keywords]
        keywords_clause = (keywords.nil? || keywords.empty?) ? '*' : keywords
        search = Spree::Product.search(keywords_clause, search_options)

        # Add any search filters passed in
        # Adding search filters modifies the search query, which is why we need to wait on executing it until after search query is modified
        search = add_search_filters(search)

        # Execute the search
        search.execute
      end
    end

    def where_clause
      # Default items for where_clause
      where_clause = {
        active: true,
        currency: pricing_options.currency,
        price: { not: nil }
      }

      taxon = @properties[:taxon]
      where_clause.merge!({taxon_ids: taxon.id}) if taxon

      # Add search attributes from params[:search]
      add_search_attributes(where_clause)
    end

    def add_search_attributes(query)
      search = @properties[:search]
      return query unless search
      search.each do |name, scope_attribute|
        query.merge!(Hash[name, scope_attribute])
      end

      query
    end

    def add_search_filters(search)
      filters = @properties[:filters]
      return search unless filters
      all_filters = taxon ? taxon.applicable_filters : Spree::Core::SearchkickFilters.all_filters

      applicable_filters = {}

      # Find filter method definition from filters passed in
      filters.to_a.each do |filter_param|
        search_filter, search_labels = filter_param
        filter = all_filters.find { |filter| filter[:scope] == search_filter.to_sym }
        applicable_filters[search_filter.to_sym] = filter[:conds].find_all { |filter_condition| search_labels.include?(filter_condition.first) }
      end

      # Loop through the applicable filters, collect the conditions, and generate filter options
      filter_items = []
      applicable_filters.each do |applicable_filter|
        filter_name, filter_details = applicable_filter
        filter_options = []
        filter_details.each do |details|
          label, conditions = details
          filter_options << conditions
        end

        # Add filter_options to filter_items for the conditions from an applicable_filter
        filter_items << {
          bool: {
            should: filter_options
          }
        }
      end

      # Set search_filters with filter_items defined above
      search_filters = {
        bool: {
          must: filter_items
        }
      }

      # Update the search query filter hash in order to process the additional filters as well as the base_search
      search.body[:query][:bool][:filter].push(search_filters)
      search
    end

    def includes_clause
      includes_clause =  { master: [:currently_valid_prices] }
      includes_clause[:master] << :images if @properties[:include_images]
      includes_clause
    end

    def prepare(params)
      @properties[:query] = params[:query].blank? ? nil : params[:query]
      @properties[:filters] = params[:filter].blank? ? nil : params[:filter]
      @properties[:fields] = params[:fields].blank? ? nil : params[:fields]
      @properties[:searchkick_options] = params[:searchkick_options].blank? ? {} : params[:searchkick_options]
      super
    end
  end
end
