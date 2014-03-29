module NormalisedBraintree
  class SaleResponse < SimpleDelegator
    class NotChargedTransaction
      def status
        'validation_errors'
      end
    end

    def transaction
      super || NotChargedTransaction.new
    end
  end
end
