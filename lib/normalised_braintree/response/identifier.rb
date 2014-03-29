module NormalisedBraintree
  module Response
    class Identifier
      def initialize result
        @result = result
      end

      def run
        case
        when authorized?
          Authorized.new @result.transaction
        when validation_errors?
          FailedValidation.new @result.errors
        when processor_declined?
          ProcessorDeclined.new @result.transaction
        when gateway_rejection?
          GatewayRejection.new @result.transaction
        when failed?
          Failed.new @result.transaction
        else Unknown.new(@result)
        end
      end

      private

      def authorized?
        statuses = %w(
          authorized
          submitted_for_settlement
        )

        statuses.include? status
      end

      def validation_errors?
        status == 'validation_errors'
      end

      def processor_declined?
        status == 'processor_declined'
      end

      def gateway_rejection?
        status == 'gateway_rejected'
      end

      def failed?
        status == 'failed'
      end

      def status
        @result.transaction.status
      end
    end
  end
end
