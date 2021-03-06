# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stackadapt/version'

Gem::Specification.new do |spec|
  spec.name          = "stackadapt"
  spec.version       = StackAdapt::version
  spec.authors       = ["RootsRated Media"]
  spec.email         = ["developers@rootsrated.com"]

  spec.summary       = %q{A Ruby interface to the StackAdapt API}
  spec.homepage      = "https://github.com/RootsRated/stackadapt-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'http', '~> 1.0'
  spec.add_dependency 'http-form_data', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
