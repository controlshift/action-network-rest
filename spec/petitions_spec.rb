require 'spec_helper'

describe ActionNetworkRest::Petitions do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:petition_id) { 'abc-def-123-456' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{petition_id}"],
        title: 'Do the Thing',
        description: 'It is oh so important',
        petition_text: 'Please, do the thing.'
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/petitions/#{petition_id}", method: :get)
        .to_return(status: 200, body: response_body)
    end

    it 'should retrieve petition data' do
      petition = subject.petitions.get(petition_id)
      expect(petition.title).to eq 'Do the Thing'
    end
  end
end
