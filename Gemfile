source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch

group :test do
  if branch == 'master' || branch >= "v2.0"
    gem 'rails-controller-testing', '~> 1.0'
  else
    gem "rails_test_params_backport"
  end
end

gem 'solidus_auth_devise'
gem 'searchkick', '>= 1.2'

gemspec
