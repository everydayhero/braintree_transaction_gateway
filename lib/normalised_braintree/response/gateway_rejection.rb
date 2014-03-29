module NormalisedBraintree
  module Response
    class GatewayRejection < Base
      NO_CODE = '9999'

      def code
        NO_CODE
      end

      def server_message
        transaction.gateway_rejection_reason
      end
    end
  end
end
