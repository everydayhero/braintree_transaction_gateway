shared_examples "a response" do
  it "responds to #code" do
    expect(response).to respond_to(:code)
  end

  it "responds to #message" do
    expect(response).to respond_to(:message)
  end

  it "responds to #success?" do
    expect(response).to respond_to(:success?)
  end

  it "responds to #server_message" do
    expect(response).to respond_to(:server_message)
  end

  it "responds to #status" do
    expect(response).to respond_to(:status)
  end

  it "responds to #credit_card_details" do
    expect(response).to respond_to(:credit_card_details)
  end
end
