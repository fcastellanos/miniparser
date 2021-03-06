# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miniparser/version'

Gem::Specification.new do |spec|
  spec.name          = "miniparser"
  spec.version       = Miniparser::VERSION
  spec.authors       = ["Fernando Castellanos"]
  spec.email         = ["fernando.castellanos@gmail.com"]
  spec.summary       = %q{A small gem to parse configuration files.}
  spec.description   = %q{MiniParser will be configurable to return different result objects.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
