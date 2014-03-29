module NormalisedBraintree
  module Response
    class FailedValidation < Base
      def code
        error.code
      end

      def server_message
        error.message
      end

      def status
        'failed_validation'
      end

      def message
        I18n.t code, 'braintree.processor', default: server_message
      end

      def credit_card_details
        OpenStruct.new
      end

      private

      def error
        transaction.first
      end
    end
  end
end
