class BraintreeTransactionGateway
  Dispute = Struct.new(
    :transaction_id,
    :received_on,
    :amount,
    :reply_by_date,
    :status,
    :reason
  ) do
    def self.from transaction_id, dispute
      new(
        transaction_id,
        dispute.received_date,
        Monetize.parse(dispute.amount.to_s('F'), dispute.currency_iso_code),
        dispute.reply_by_date,
        dispute.status,
        dispute.reason,
      )
    end

    def created_between? from, to
      (from..to).cover? received_on
    end
  end
end
