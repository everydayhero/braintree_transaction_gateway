# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'braintree_transaction_gateway/version'

Gem::Specification.new do |spec|
  spec.name          = "braintree_transaction_gateway"
  spec.version       = BraintreeTransactionGateway::VERSION
  spec.authors       = ["Tim Cooper", "Jonathon M. Abbott"]
  spec.email         = ["coop@latrobest.com", "jma@dandaraga.net"]
  spec.summary       = %q{Braintree Transaction API Gateway}
  spec.homepage      = "https://github.com/everydayhero/braintree_transaction_gateway"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"

  spec.add_runtime_dependency "braintree", "~> 2.29"
  spec.add_runtime_dependency "activesupport", ">= 4.0.0"
  spec.add_runtime_dependency "i18n", ['>= 0.6.4', '<= 0.7.0']
  spec.add_runtime_dependency "money"
  spec.add_runtime_dependency "monetize"
end
