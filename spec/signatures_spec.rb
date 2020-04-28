require 'spec_helper'

describe ActionNetworkRest::Signatures do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:petition_id) { 'abc-def-123-456' }
    let(:signature_id) { '789-ghi-321-jkl' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{signature_id}"],
        'action_network:person_id' => '699da712-929f-11e3-a2e9-12313d316c29',
        'action_network:petition_id' => petition_id
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/petitions/#{petition_id}/signatures/#{signature_id}", method: :get)
        .to_return(status: 200, body: response_body)
    end

    it 'should retrieve signature data' do
      signature = subject.signatures.get(petition_id: petition_id, id: signature_id)
      expect(signature.action_network_id).to eq signature_id
    end
  end
end
