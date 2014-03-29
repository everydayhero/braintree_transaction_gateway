require "helper"

describe NormalisedBraintree::Response::Unknown do
  it_behaves_like "a response"

  let(:response) { NormalisedBraintree::Response::Unknown.new(double) }

  it "#success? is false" do
    expect(response.success?).to be_false
  end

  it "#transaction_id" do
    expect(response.transaction_id).to be_nil
  end

  it "#code is hardcoded" do
    expect(response.code).to eq('8000')
  end

  it "#status is hardcoded" do
    expect(response.status).to eq('unknown')
  end
end
