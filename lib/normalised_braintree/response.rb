require "i18n"
require "normalised_braintree/response/base"
require "normalised_braintree/response/authorized"
require "normalised_braintree/response/failed_validation"
require "normalised_braintree/response/gateway_rejection"
require "normalised_braintree/response/processor_declined"
require "normalised_braintree/response/failed"
require "normalised_braintree/response/unknown"
require "normalised_braintree/response/identifier"

module NormalisedBraintree
  module Response
    def self.identify result
      Identifier.new(result).run
    end
  end
end
