require "helper"

describe BraintreeTransactionGateway do
  let(:gateway) { BraintreeTransactionGateway.new }

  describe "#charge" do
    context "when successful" do
      before do
        use_cassette("charge-success") do
          @result = gateway.charge(successful_sale_options)
        end
      end

      it "is successful" do
        expect(@result.success?).to be_true
      end

      it "has a transaction_id" do
        expect(@result.transaction_id).to eq("7fhzzr")
      end
    end

    context "when unsuccessful" do
      before do
        use_cassette("charge-processor_declined") do
          @result = gateway.charge(unsuccessful_sale_options)
        end
      end

      it "is unsuccessful" do
        expect(@result.success?).to be_false
      end
    end

    context "with an invalid credit card" do
      before do
        use_cassette("charge-failed_validation") do
          @result = gateway.charge invalid_credit_card_sale_options
        end
      end

      it "is unsuccessful" do
        expect(@result.success?).to be_false
      end

      it "returns a code" do
        expect(@result.code).to eq("81717")
      end

      it "has a message" do
        message = "Credit card number is not an accepted test number."
        expect(@result.message).to eq(message)
      end
    end
  end

  describe "#escrow_status" do
    context "for an existing transaction" do
      before do
        use_cassette("escrow_status-held") do
          @result = gateway.escrow_status("5wb5g6")
        end
      end

      it "returns the status" do
        expect(@result).to eq("held")
      end
    end

    context "for a missing transaction" do
      it "raises an exception" do
        use_cassette("escrow_status-missing") do
          expect { gateway.escrow_status("garbage") }
            .to raise_error(BraintreeTransactionGateway::TransactionMissing)
        end
      end
    end
  end

  describe "#locate" do
    context "for an existing transaction" do
      context "successful transaction" do
        let(:order_id) { "test-abcd1234" }

        before do
          use_cassette("locate-success") do
            gateway.charge successful_sale_options order_id: order_id

            @result = gateway.locate order_id
          end
        end

        it "is successful" do
          expect(@result.success?).to be_true
        end

        it "has a transaction_id" do
          expect(@result.transaction_id).to eq("9gnfcw")
        end
      end

      context "failed transaction" do
        let(:order_id) { "test-deadbeef-2" }

        before do
          use_cassette("locate-failure") do
            gateway.charge unsuccessful_sale_options order_id: order_id

            @result = gateway.locate order_id
          end
        end

        it "is unsuccessful" do
          expect(@result.success?).to be_false
        end

        it "has a transaction_id" do
          expect(@result.transaction_id).to eq("hxwnhb")
        end
      end
    end

    context "for an unknown transaction" do
      it "raises an exception" do
        use_cassette("locate-unknown") do
          expect { gateway.locate("chucktesta") }
            .to raise_error(BraintreeTransactionGateway::TransactionMissing)
        end
      end
    end
  end

  context "#release" do
    it "returns true with a successful transaction" do
      use_cassette("release-success") do
        expect(gateway.release("g8fyvr")).to be_true
      end
    end

    it "returns false with a non-held transaction" do
      use_cassette("release-failure") do
        expect(gateway.release("73fxwb")).to be_false
      end
    end

    it "returns false with a missing transaction" do
      use_cassette("release-missing") do
        expect(gateway.release("notarealid")).to be_false
      end
    end
  end

  describe "#refund" do
    it "returns a success result with a successful transaction" do
      use_cassette("refund-success") do
        result = gateway.refund "9tdbbw"

        expect(result.success?).to be_true
      end
    end

    it "returns an unsuccessful result with a missing transaction" do
      use_cassette("refund-missing") do
        result = gateway.refund "does-not-exist"

        expect(result.success?).to be_false
      end
    end

    it "returns an unsuccessful result with a failed transaction" do
      use_cassette("refund-failing") do
        result = gateway.refund "test-deadbeef-2"

        expect(result.success?).to be_false
      end
    end
  end

  private

  def successful_sale_options options = {}
    {
      amount: "100.0",
      service_fee_amount: "5.00",
      options: {
        hold_in_escrow: true,
        submit_for_settlement: true,
      },
      credit_card: {
        number: "4111111111111111",
        expiration_month: "05",
        expiration_year: "2014",
        cvv: "123",
      },
      merchant_account_id: "04arts_foundation_g3jkdb_troll",
    }.merge options
  end

  def unsuccessful_sale_options options = {}
    successful_sale_options.merge(
      amount: "2000",
    ).merge options
  end

  def invalid_credit_card_sale_options options = {}
    successful_sale_options.merge(
      credit_card: {
        number: "5444444444444445",
        expiration_month: "05",
        expiration_year: "2014",
        cvv: "123",
      },
    ).merge options
  end

  def use_cassette name, &block
    formatted_name = format "BraintreeTransactionGateway-%s", name

    VCR.use_cassette formatted_name, &block
  end
end
