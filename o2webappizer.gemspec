# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'o2webappizer/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= #{O2webappizer::RUBY_VERSION}"

  spec.name          = "o2webappizer"
  spec.version       = O2webappizer::VERSION
  spec.authors       = ["Patrice Lebel"]
  spec.email         = ["patrice@lebel.com"]

  spec.summary       = "Project Boilerplate Builder used by O2Web"
  spec.description   = "Project Boilerplate Builder used by O2Web"
  spec.homepage      = "https://github.com/o2web/o2webappizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["o2webappizer"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', "~> #{O2webappizer::RAILS_VERSION}", ">= #{O2webappizer::RAILS_VERSION}.0"

  spec.add_runtime_dependency 'bundler', '~> 1.10', '~> 1.3'

  spec.add_development_dependency "rake", "~> 10.0"
end
