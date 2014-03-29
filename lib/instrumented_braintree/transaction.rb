module InstrumentedBraintree
  class Transaction < SimpleDelegator
    def initialize object = NormalisedBraintree::Transaction.new
      super
    end

    def sale *args
      instrument('sale.transaction.braintree') do |payload|
        result = super
        payload[:status] = result.status
        payload[:code] = result.code
        result
      end
    end

    def find *args
      instrument('find.transaction.braintree') do |payload|
        begin
          result = super
          payload[:not_found] = false
        rescue Braintree::NotFoundError => e
          payload[:not_found] = true
          raise e
        end

        result
      end
    end

    def search &block
      instrument('search.transaction.braintree') do |payload|
        result = super
        payload[:not_found] = result.empty?

        result
      end
    end

    def release_from_escrow *args
      instrument('release_from_escrow.transaction.braintree') do |payload|
        begin
          result = super
          payload[:not_found] = false
        rescue Braintree::NotFoundError => e
          payload[:not_found] = true
          raise e
        end

        result
      end
    end

    def refund *args
      instrument('refund.transaction.braintree') do |payload|
        begin
          result = super
          payload[:not_found] = false
        rescue Braintree::NotFoundError => e
          payload[:not_found] = true
          raise e
        end

        result
      end
    end

    private

    def instrument *args, &block
      InstrumentedBraintree.instrumenter.instrument *args, &block
    end
  end
end
