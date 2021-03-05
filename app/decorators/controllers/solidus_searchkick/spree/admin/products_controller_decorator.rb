module SolidusSearchkick
  module Spree
    module Admin
      module ProductsControllerDecorator
        def autocomplete
          keywords = params[:keywords] ||= nil
          json = ::Spree::Product.autocomplete(keywords)
          render json: json
        end

        ::Spree::Admin::ProductsController.prepend self
      end
    end
  end
end
