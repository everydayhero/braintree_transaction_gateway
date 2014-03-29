require "helper"

describe NormalisedBraintree::Response::ProcessorDeclined do
  it_behaves_like "a response"

  let(:transaction) do
    double(
      processor_response_code: '2000',
      processor_response_text: 'Hi',
      id: '1',
    )
  end
  let(:response) { NormalisedBraintree::Response::ProcessorDeclined.new(transaction) }

  it "#success? is false" do
    expect(response.success?).to be_false
  end

  it "#transaction_id" do
    expect(response.transaction_id).to eq('1')
  end
end
