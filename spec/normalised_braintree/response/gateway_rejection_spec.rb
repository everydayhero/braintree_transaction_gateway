require "helper"

describe NormalisedBraintree::Response::GatewayRejection do
  it_behaves_like "a response"

  let(:response) { NormalisedBraintree::Response::GatewayRejection.new(double) }

  it "#success? is false" do
    expect(response.success?).to be_false
  end

  it "#code is hardcoded" do
    expect(response.code).to eq('9999')
  end
end
