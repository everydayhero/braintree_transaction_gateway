module NormalisedBraintree
  module Response
    class ProcessorDeclined < Base
      def code
        transaction.processor_response_code
      end

      def server_message
        transaction.processor_response_text
      end
    end
  end
end
