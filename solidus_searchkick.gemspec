# encoding: UTF-8
require File.expand_path("../lib/solidus_searchkick/version", __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_searchkick'
  s.version     = SolidusSearchkick::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Add searchkick to Solidus'
  s.description = 'Filters, suggests, autocompletes, sortings, searches'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = ['Jim Smith']
  s.email     = ['jim@jimsmithdesign.com']
  s.homepage  = 'https://github.com/elevatorup/solidus_searchkick'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency     'solidus', '~> 2.0'
  s.add_runtime_dependency     'searchkick', '>= 1.2'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot', '~> 4.10'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 5.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
end
