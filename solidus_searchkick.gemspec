# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_searchkick/version'

Gem::Specification.new do |s|
  s.name = 'solidus_searchkick'
  s.version = SolidusSearchkick::VERSION
  s.summary = 'Add searchkick to Solidus'
  s.description = 'Filters, suggests, autocompletes, sortings, searches'
  s.license = 'MIT'

  s.author = 'Jim Smith'
  s.email = 'jim@jimsmithdesign.com'
  s.homepage = 'https://github.com/solidusio-contrib/solidus_searchkick'

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.required_ruby_version = '~> 2.4'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'searchkick', '>= 1.2'
  s.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  s.add_dependency 'solidus_support', '~> 0.5'

  s.add_development_dependency 'solidus_dev_support'
end
