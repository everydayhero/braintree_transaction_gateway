module NormalisedBraintree
  module Response
    class Authorized < Base
      def success?
        true
      end

      def server_message
        ''
      end

      def code
        transaction.processor_response_code
      end
    end
  end
end
