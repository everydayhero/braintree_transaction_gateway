class BraintreeTransactionGateway
  class Configuration < SimpleDelegator
    def initialize config = Braintree::Configuration
      super
    end

    def environment= value
      __getobj__.environment = value.to_sym
    end
  end
end
