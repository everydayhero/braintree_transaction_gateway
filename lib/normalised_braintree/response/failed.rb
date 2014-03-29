module NormalisedBraintree
  module Response
    class Failed < Base
      def code
        '3000'
      end

      def server_message
        'Processor Network Unavailable - Try Again'
      end

      def credit_card_details
        OpenStruct.new
      end
    end
  end
end
