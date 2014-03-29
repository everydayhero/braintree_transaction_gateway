require "helper"

describe NormalisedBraintree::Response::Authorized do
  it_behaves_like "a response"

  let(:transaction) { double(processor_response_code: '2000', id: '1') }
  let(:response) { NormalisedBraintree::Response::Authorized.new(transaction) }

  it "#success? is true" do
    expect(response.success?).to be_true
  end

  it "#transaction_id" do
    expect(response.transaction_id).to eq('1')
  end
end
