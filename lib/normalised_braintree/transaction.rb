require 'normalised_braintree/sale_response'

module NormalisedBraintree
  class Transaction < SimpleDelegator
    def initialize object = Braintree::Transaction
      super
    end

    def sale *args
      Response.identify SaleResponse.new(__getobj__.sale(*args))
    end

    def refund *args
      Response.identify __getobj__.refund(*args)
    end

    def search &block
      transactions = __getobj__.search &block

      transactions.map do |transaction|
        Response.identify OpenStruct.new(transaction: transaction)
      end
    end
  end
end
