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

  describe '#create' do
    let(:petition_id) { 'abc-def-123-456' }
    let(:signature_data) do
      {
        identifiers: ['some_system:123'],
        comments: 'This petition is so important to me'
      }
    end
    let(:person_data) do
      {
        given_name: 'Isaac',
        family_name: 'Asimov',
        postal_addresses: [{postal_code: '12345'}],
        email_addresses: [{address: 'asimov@example.com'}]
      }
    end
    let(:request_body) { signature_data.merge(person: person_data) }
    let(:signature_id) { '789-ghi-321-jkl' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{signature_id}"],
        'action_network:person_id' => '699da712-929f-11e3-a2e9-12313d316c29',
        'action_network:petition_id' => petition_id
      }.to_json
    end

    let!(:post_stub) do
      stub_actionnetwork_request("/petitions/#{petition_id}/signatures/", method: :post, body: request_body)
        .to_return(status: 200, body: response_body)
    end

    it 'should POST signature data' do
      signature = subject.signatures.create(petition_id: petition_id,
                                            signature_data: signature_data,
                                            person_data: person_data)

      expect(post_stub).to have_been_requested

      expect(signature.action_network_id).to eq signature_id
    end

    context 'with tags' do
      let(:request_body) { signature_data.merge(person: person_data, add_tags: ['foo', 'bar']) }

      it 'should include tags in post' do
        signature = subject.signatures.create(petition_id: petition_id,
                                              signature_data: signature_data,
                                              person_data: person_data,
                                              tags: ['foo', 'bar'])

        expect(post_stub).to have_been_requested

        expect(signature.action_network_id).to eq signature_id
      end
    end
  end

  describe '#update' do
    let(:petition_id) { 'abc-def-123-456' }
    let(:signature_id) { '789-ghi-321-jkl' }
    let(:signature_data) do
      {
        identifiers: ['another_system:234'],
        comments: 'some more comments'
      }
    end
    let(:response_body) do
      {
        identifiers: ["action_network:#{signature_id}", 'another_system:234'],
        'action_network:person_id' => '699da712-929f-11e3-a2e9-12313d316c29',
        'action_network:petition_id' => petition_id
      }.to_json
    end
    let!(:put_stub) do
      stub_actionnetwork_request("/petitions/#{petition_id}/signatures/#{signature_id}",
                                 method: :put, body: signature_data)
        .to_return(status: 200, body: response_body)
    end

    it 'should PUT signature data' do
      updated_signature = subject.signatures.update(petition_id: petition_id, id: signature_id,
                                                    signature_data: signature_data)

      expect(put_stub).to have_been_requested

      expect(updated_signature.action_network_id).to eq signature_id
    end
  end
end
