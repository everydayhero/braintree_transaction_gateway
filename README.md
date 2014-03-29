# BraintreeTransactionGateway

BraintreeTransactionGateway encapsulates access to Braintree's [transaction
API](https://www.braintreepayments.com/docs/ruby/transactions/overview).

Instrumentation is provided by `ActiveSupport::Notifications`.

## Installation

This library is currently undergoing development and has not been released as a
gem. Add this line to your application's Gemfile:

    gem 'braintree_transaction_gateway', github: 'everydayhero/braintree_transaction_gateway'

And then execute:

    $ bundle

## Usage

``` ruby
BraintreeTransactionGateway.configure do |config|
  config.environment = "sandbox"
  config.merchant_id = "your_merchant_id"
  config.public_key = "your_public_key"
  config.private_key = "your_private_key"
end

braintree = BraintreeTransactionGateway.new
braintree.charge options
```

## Contributing

1. Fork it (http://github.com/everydayhero/braintree_transaction_gateway/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
