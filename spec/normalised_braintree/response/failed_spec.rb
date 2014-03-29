require "helper"

describe NormalisedBraintree::Response::Failed do
  it_behaves_like "a response"

  let(:transaction) { double(id: '1') }
  let(:response) { NormalisedBraintree::Response::Failed.new(transaction) }

  it "#success? is false" do
    expect(response.success?).to be_false
  end

  it "#transaction_id" do
    expect(response.transaction_id).to eq('1')
  end

  it "#code is hardcoded" do
    expect(response.code).to eq('3000')
  end
end
