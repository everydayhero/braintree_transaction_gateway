require 'active_support/notifications'

module InstrumentedBraintree
  def self.instrumenter
    @instrumenter ||= ActiveSupport::Notifications
  end

  def self.instrumenter= new_instrumenter
    @instrumenter = new_instrumenter
  end
end

require 'instrumented_braintree/transaction'
require 'normalised_braintree'
