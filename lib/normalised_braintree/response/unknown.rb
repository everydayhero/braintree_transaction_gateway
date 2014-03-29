module NormalisedBraintree
  module Response
    class Unknown < Base
      def code
        '8000'
      end

      def server_message
        'Processor Network Unavailable - Try Again'
      end

      def transaction_id
        nil
      end

      def status
        'unknown'
      end
    end
  end
end
