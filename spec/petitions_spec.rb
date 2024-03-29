# frozen_string_literal: true

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
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should retrieve petition data' do
      petition = subject.petitions.get(petition_id)
      expect(petition.title).to eq 'Do the Thing'
    end
  end

  describe '#list' do
    let(:response_body) do
      {
        _embedded: {
          'osdi:petitions' => [
            {
              identifiers: ['action_network:a4dde5b6-0512-48ea-b4ad-63a71117b43d'],
              title: 'Stop doing the bad thing'
            },
            {
              identifiers: ['action_network:a27178b9-45c3-4844-8ebf-ebd5da74a1e3'],
              title: 'We need to do this now!'
            }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request('/petitions/?page=1', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retrieve the petitions data from first page when calling without an argument' do
        petitions = subject.petitions.list

        expect(petitions.count).to eq 2
        expect(petitions.first.action_network_id).to eq 'a4dde5b6-0512-48ea-b4ad-63a71117b43d'
        expect(petitions.first.title).to eq 'Stop doing the bad thing'
        expect(petitions.last.action_network_id).to eq 'a27178b9-45c3-4844-8ebf-ebd5da74a1e3'
        expect(petitions.last.title).to eq 'We need to do this now!'
      end

      it 'should retrieve the petitions data from first page when calling with page argument' do
        petitions = subject.petitions.list(page: 1)

        expect(petitions.count).to eq 2
        expect(petitions.first.action_network_id).to eq 'a4dde5b6-0512-48ea-b4ad-63a71117b43d'
        expect(petitions.first.title).to eq 'Stop doing the bad thing'
        expect(petitions.last.action_network_id).to eq 'a27178b9-45c3-4844-8ebf-ebd5da74a1e3'
        expect(petitions.last.title).to eq 'We need to do this now!'
      end
    end

    context 'requesting page 10' do
      before :each do
        stub_actionnetwork_request('/petitions/?page=10', method: :get)
          .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      end

      it 'should retrieve the petitions data from requested page number' do
        petitions = subject.petitions.list(page: 10)

        expect(petitions.count).to eq 2
        expect(petitions.first.action_network_id).to eq 'a4dde5b6-0512-48ea-b4ad-63a71117b43d'
        expect(petitions.first.title).to eq 'Stop doing the bad thing'
        expect(petitions.last.action_network_id).to eq 'a27178b9-45c3-4844-8ebf-ebd5da74a1e3'
        expect(petitions.last.title).to eq 'We need to do this now!'
      end
    end
  end

  describe '#create' do
    let(:petition_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'Do the Thing!',
        origin_system: 'Some System'
      }
    end
    let(:request_body) { petition_data }
    let(:response_body) do
      {
        identifiers: ['somesystem:123', 'action_network:123-456-789-abc'],
        title: 'Do the Thing!',
        origin_system: 'Some System'
      }.to_json
    end
    let!(:post_stub) do
      stub_actionnetwork_request('/petitions/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should POST petition data' do
      petition = subject.petitions.create(petition_data)

      expect(post_stub).to have_been_requested

      expect(petition.identifiers).to contain_exactly('action_network:123-456-789-abc',
                                                      'somesystem:123')
      expect(petition.action_network_id).to eq '123-456-789-abc'
    end

    context 'with a creator_person_id' do
      let(:person_id) { 'c945d6fe-929e-11e3-a2e9-12313d316c29' }
      let(:person_url) { "https://actionnetwork.org/api/v2/people/#{person_id}" }
      let(:request_body) do
        petition_data.merge({ '_links' => { 'osdi:creator' => { 'href' => person_url } } })
      end

      it 'should include a link to the creator' do
        petition = subject.petitions.create(petition_data, creator_person_id: person_id)

        expect(post_stub).to have_been_requested

        expect(petition.action_network_id).to eq '123-456-789-abc'
      end
    end
  end

  describe '#update' do
    let(:petition_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'Do the Thing!',
        origin_system: 'Some System'
      }
    end
    let(:petition_id) { '123-456-789-abc' }
    let(:response_body) do
      {
        identifiers: ['somesystem:123', "action_network:#{petition_id}"],
        title: 'Do the Thing!',
        origin_system: 'Some System'
      }.to_json
    end
    let!(:put_stub) do
      stub_actionnetwork_request("/petitions/#{petition_id}", method: :put, body: petition_data)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should PUT petition data' do
      updated_petition = subject.petitions.update(petition_id, petition_data)

      expect(put_stub).to have_been_requested

      expect(updated_petition.identifiers).to contain_exactly('action_network:123-456-789-abc',
                                                              'somesystem:123')
    end
  end
end
