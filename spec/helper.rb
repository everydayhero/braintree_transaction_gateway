$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "vcr"
require "support/response_lint"
require "braintree_transaction_gateway"

I18n.enforce_available_locales = false

BraintreeTransactionGateway.configure do |config|
  config.environment = "sandbox"
  config.merchant_id = "your_merchant_id"
  config.public_key = "your_public_key"
  config.private_key = "your_private_key"
  config.logger = Logger.new "/dev/null"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.ignore_localhost = true
  config.filter_sensitive_data("<BRAINTREE_PRIVATE_KEY>") do
    BraintreeTransactionGateway.configuration.private_key
  end
  config.filter_sensitive_data("<BRAINTREE_PUBLIC_KEY>") do
    BraintreeTransactionGateway.configuration.public_key
  end
  config.filter_sensitive_data("<BRAINTREE_MERCHANT_ID>") do
    BraintreeTransactionGateway.configuration.merchant_id
  end
end
