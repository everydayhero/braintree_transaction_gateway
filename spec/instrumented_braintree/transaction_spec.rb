require 'helper'

describe InstrumentedBraintree::Transaction do
  let(:instrumenter) { FakeInstrumenter.new }

  before do
    InstrumentedBraintree.instrumenter = instrumenter
  end

  describe "#sale" do
    it "instruments when called" do
      payload = {
        status: 'authorized',
        code: '1',
      }
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:sale) { OpenStruct.new(status: 'authorized', code: '1') }
      end.new)

      transaction.sale

      expect(payload).to eq(instrumenter.payload)
      expect(prefix('sale')).to eq(instrumenter.name)
    end
  end

  describe "#find" do
    it "instruments when a transaction is found" do
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:find) { }
      end.new)

      transaction.find

      expect({not_found: false}).to eq(instrumenter.payload)
      expect(prefix('find')).to eq(instrumenter.name)
    end

    it "instruments when a transaction is not found" do
      begin
        transaction = InstrumentedBraintree::Transaction.new(Class.new do
          define_method(:find) { raise Braintree::NotFoundError }
        end.new)

        transaction.find
      rescue Braintree::NotFoundError
        expect({not_found: true}).to eq(instrumenter.payload)
        expect(prefix('find')).to eq(instrumenter.name)
      end
    end
  end

  describe "#search" do
    it "instruments with results" do
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:search) { %w(lots of results) }
      end.new)

      transaction.search

      expect({not_found: false}).to eq(instrumenter.payload)
      expect(prefix('search')).to eq(instrumenter.name)
    end

    it "instruments without results" do
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:search) { [] }
      end.new)

      transaction.search

      expect({not_found: true}).to eq(instrumenter.payload)
      expect(prefix('search')).to eq(instrumenter.name)
    end
  end

  describe "#release_from_escrow" do
    it "instruments with an existing transaction" do
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:release_from_escrow) { }
      end.new)

      transaction.release_from_escrow

      expect({not_found: false}).to eq(instrumenter.payload)
      expect(prefix('release_from_escrow')).to eq(instrumenter.name)
    end

    it "instruments with a non-existing transaction" do
      begin
        transaction = InstrumentedBraintree::Transaction.new(Class.new do
          define_method(:release_from_escrow) { raise Braintree::NotFoundError }
        end.new)

        transaction.release_from_escrow
      rescue Braintree::NotFoundError
        expect({not_found: true}).to eq(instrumenter.payload)
        expect(prefix('release_from_escrow')).to eq(instrumenter.name)
      end
    end
  end

  describe "#refund" do
    it "instruments with an existing transaction" do
      transaction = InstrumentedBraintree::Transaction.new(Class.new do
        define_method(:refund) { }
      end.new)

      transaction.refund

      expect({not_found: false}).to eq(instrumenter.payload)
      expect(prefix('refund')).to eq(instrumenter.name)
    end

    it "instruments with a non-existing transaction" do
      begin
        transaction = InstrumentedBraintree::Transaction.new(Class.new do
          define_method(:refund) { raise Braintree::NotFoundError }
        end.new)

        transaction.refund
      rescue Braintree::NotFoundError
        expect({not_found: true}).to eq(instrumenter.payload)
        expect(prefix('refund')).to eq(instrumenter.name)
      end
    end
  end

  private

  def prefix key
    format '%s.transaction.braintree', key
  end

  class FakeInstrumenter
    attr_reader :payload
    attr_reader :name

    def initialize
      @payload = {}
    end

    def instrument name
      @name = name
      yield payload
    end
  end
end
