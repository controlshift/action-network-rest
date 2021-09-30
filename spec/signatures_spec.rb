# frozen_string_literal: true

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
      signature = subject.petitions(petition_id).signatures.get(signature_id)
      expect(signature.action_network_id).to eq signature_id
    end
  end

  describe '#list' do
    let(:petition_id) { 'abc-def-123-456' }

    let(:response_body) do
      {
        _embedded: {
          'osdi:signatures' => [
            {
              identifiers: ['action_network:d6bdf50e-c3a4-4981-a948-3d8c086066d7'],
              'action_network:person_id' => '699da712-929f-11e3-a2e9-12313d316c29',
              'action_network:petition_id' => petition_id
            },
            {
              identifiers: ['action_network:71497ab2-b3e7-4896-af46-126ac7287dab'],
              'action_network:person_id' => 'c945d6fe-929e-11e3-a2e9-12313d316c29',
              'action_network:petition_id' => petition_id
            }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request("/petitions/#{petition_id}/signatures/?page=1", method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retrieve the signatures data from first page when calling without an argument' do
        signatures = subject.petitions(petition_id).signatures.list

        expect(signatures.count).to eq 2
        expect(signatures.first.action_network_id).to eq 'd6bdf50e-c3a4-4981-a948-3d8c086066d7'
        expect(signatures.first['action_network:person_id']).to eq '699da712-929f-11e3-a2e9-12313d316c29'
        expect(signatures.last.action_network_id).to eq '71497ab2-b3e7-4896-af46-126ac7287dab'
        expect(signatures.last['action_network:person_id']).to eq 'c945d6fe-929e-11e3-a2e9-12313d316c29'
      end

      it 'should retrieve the signatures data from first page when calling with page argument' do
        signatures = subject.petitions(petition_id).signatures.list(page: 1)

        expect(signatures.count).to eq 2
        expect(signatures.first.action_network_id).to eq 'd6bdf50e-c3a4-4981-a948-3d8c086066d7'
        expect(signatures.first['action_network:person_id']).to eq '699da712-929f-11e3-a2e9-12313d316c29'
        expect(signatures.last.action_network_id).to eq '71497ab2-b3e7-4896-af46-126ac7287dab'
        expect(signatures.last['action_network:person_id']).to eq 'c945d6fe-929e-11e3-a2e9-12313d316c29'
      end
    end

    context 'requesting page 10' do
      before :each do
        stub_actionnetwork_request("/petitions/#{petition_id}/signatures/?page=10", method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retrieve the signatures data from requested page number' do
        signatures = subject.petitions(petition_id).signatures.list(page: 10)

        expect(signatures.count).to eq 2
        expect(signatures.first.action_network_id).to eq 'd6bdf50e-c3a4-4981-a948-3d8c086066d7'
        expect(signatures.first['action_network:person_id']).to eq '699da712-929f-11e3-a2e9-12313d316c29'
        expect(signatures.last.action_network_id).to eq '71497ab2-b3e7-4896-af46-126ac7287dab'
        expect(signatures.last['action_network:person_id']).to eq 'c945d6fe-929e-11e3-a2e9-12313d316c29'
      end
    end
  end

  describe '#create' do
    let(:petition_id) { 'abc-def-123-456' }
    let(:signature_data) do
      {
        identifiers: ['some_system:123'],
        comments: 'This petition is so important to me',
        person: {
          given_name: 'Isaac',
          family_name: 'Asimov',
          postal_addresses: [{ postal_code: '12345' }],
          email_addresses: [{ address: 'asimov@example.com' }]
        }
      }
    end
    let(:request_body) { signature_data }
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
      signature = subject.petitions(petition_id).signatures.create(signature_data)

      expect(post_stub).to have_been_requested

      expect(signature.action_network_id).to eq signature_id
    end

    # Action Network treats the signature create helper endpoint as an unauthenticated
    # "blind" POST (see https://actionnetwork.org/docs/v2/unauthenticated-post/). For this
    # reason they don't return a status code with error to avoid leaking private data. Instead
    # they return 200 OK with an empty body (vs. the newly created signature's data for successful calls)
    context 'response body is empty' do
      let(:response_body) { {}.to_json }

      it 'should raise error' do
        expect { subject.petitions(petition_id).signatures.create(signature_data) }
          .to(raise_error(ActionNetworkRest::Signatures::CreateError))
      end
    end

    context 'with tags' do
      let(:request_body) { signature_data.merge(add_tags: %w[foo bar]) }

      it 'should include tags in post' do
        signature = subject.petitions(petition_id).signatures.create(signature_data, tags: %w[foo bar])

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
      updated_signature = subject.petitions(petition_id).signatures.update(signature_id, signature_data)

      expect(put_stub).to have_been_requested

      expect(updated_signature.action_network_id).to eq signature_id
    end
  end
end
