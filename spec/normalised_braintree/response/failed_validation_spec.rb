require "helper"

describe NormalisedBraintree::Response::FailedValidation do
  it_behaves_like "a response"

  let(:errors) do
    [
      double(code: '1', message: 'Hi 1'),
      double(code: '2', message: 'Hi 2'),
    ]
  end
  let(:response) { NormalisedBraintree::Response::FailedValidation.new(errors) }

  it "#success? is false" do
    expect(response.success?).to be_false
  end

  it "#code is pulled from the first error" do
    expect(response.code).to eq('1')
  end

  it "#message is pulled from the first error" do
    expect(response.message).to eq('Hi 1')
  end

  it "#status is hardcoded" do
    expect(response.status).to eq('failed_validation')
  end
end
