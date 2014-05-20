require "braintree"
require "braintree_transaction_gateway/version"
require "braintree_transaction_gateway/configuration"
require "instrumented_braintree"

class BraintreeTransactionGateway
  TransactionMissing = Class.new StandardError

  @client ||= InstrumentedBraintree::Transaction.new
  class << self; attr_accessor :client; end

  def self.configure
    @configuration ||= Configuration.new
    yield @configuration
  end

  def self.configuration
    @configuration
  end

  def charge *args
    client.sale *args
  end

  def escrow_status transaction_id
    client.find(transaction_id).escrow_status
  rescue Braintree::NotFoundError
    raise TransactionMissing, transaction_id
  end

  def locate reference_id
    transaction_with_order_id reference_id
  end

  def release reference_id
    client.release_from_escrow(reference_id).success?
  rescue Braintree::NotFoundError
    false
  end

  def refund reference_id
    client.refund reference_id
  rescue Braintree::NotFoundError
    OpenStruct.new success?: false
  end

  def refund_settled_at transaction_id
    event = client
      .find(transaction_id)
      .status_history
      .find { |event| event.status == 'settled' }
    event.timestamp if event
  rescue Braintree::NotFoundError
    raise TransactionMissing, transaction_id
  end

  private

  def transaction_with_order_id order_id
    client
      .search { |search| search.order_id.is order_id }
      .first || raise(TransactionMissing, order_id.to_s)
  end

  def client
    self.class.client
  end
end
