module NormalisedBraintree
  module Response
    Base = Struct.new :transaction do
      extend Forwardable

      def_delegator :transaction, :status
      def_delegator :transaction, :id, :transaction_id
      def_delegator :transaction, :credit_card_details

      def message
        I18n.t code, scope: 'processor.braintree', default: server_message
      end

      def success?
        false
      end
    end
  end
end
