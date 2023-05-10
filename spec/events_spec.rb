# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Events do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:response_body) { { some: 'data' }.to_json }

    before :each do
      stub_actionnetwork_request('/events/123', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should return the response' do
      expect(subject.events.get(123)).to eq({ 'some' => 'data' })
    end
  end

  describe '#list' do
    let(:response_body) { fixture('events/list.json') }

    it 'should return the response' do
      stub_actionnetwork_request('/events/?page=1', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })

      expect(subject.events.list.length).to eq(2)
      expect(subject.events.list.first).to include({ 'action_network_id' => '8a625981-67a4-4457-8b55-2e30b267b2c2' })
    end

    it 'should support event_campaign listing' do
      stub_request = stub_actionnetwork_request('/event_campaigns/foo/events/?page=1', method: :get)
                     .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })

      subject.event_campaigns('foo').events.list

      expect(stub_request).to have_been_requested
    end

    it 'should paginate' do
      stub_request = stub_actionnetwork_request('/events/?page=2', method: :get)
                     .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      subject.events.list(page: 2)
      expect(stub_request).to have_been_requested
    end
  end

  describe '#create' do
    let(:event_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'My Great Event',
        origin_system: 'Some System'
      }
    end
    let(:request_body) { event_data }
    let(:response_body) do
      {
        identifiers: ['somesystem:123', 'action_network:123-456-789-abc'],
        title: 'My Great Event',
        origin_system: 'Some System'
      }.to_json
    end
    let!(:post_stub) do
      stub_actionnetwork_request('/events/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should POST event data' do
      event = subject.events.create(event_data)

      expect(post_stub).to have_been_requested

      expect(event.identifiers).to contain_exactly('action_network:123-456-789-abc',
                                                   'somesystem:123')
      expect(event.action_network_id).to eq '123-456-789-abc'
    end

    context 'with a creator_person_id' do
      let(:person_id) { 'c945d6fe-929e-11e3-a2e9-12313d316c29' }
      let(:person_url) { "https://actionnetwork.org/api/v2/people/#{person_id}" }
      let(:request_body) do
        event_data.merge({ '_links' => { 'osdi:creator' => { 'href' => person_url } } })
      end

      it 'should include a link to the creator' do
        event = subject.events.create(event_data, creator_person_id: person_id)

        expect(post_stub).to have_been_requested

        expect(event.action_network_id).to eq '123-456-789-abc'
      end
    end

    context 'with an organizer_person_id' do
      let(:person_id) { 'c945d6fe-929e-11e3-a2e9-12313d316c29' }
      let(:person_url) { "https://actionnetwork.org/api/v2/people/#{person_id}" }
      let(:request_body) do
        event_data.merge({ '_links' => { 'osdi:organizer' => { 'href' => person_url } } })
      end

      it 'should include a link to the organizer' do
        event = subject.events.create(event_data, organizer_person_id: person_id)

        expect(post_stub).to have_been_requested

        expect(event.action_network_id).to eq '123-456-789-abc'
      end
    end

    context 'with a creator_person_id and an organizer_person_id' do
      let(:person_1_id) { 'c945d6fe-929e-11e3-a2e9-12313d316c29' }
      let(:person_1_url) { "https://actionnetwork.org/api/v2/people/#{person_1_id}" }
      let(:person_2_id) { '186d5368-28d3-4a49-99af-e70e40fadb6b' }
      let(:person_2_url) { "https://actionnetwork.org/api/v2/people/#{person_2_id}" }
      let(:request_body) do
        event_data.merge({
                           '_links' => {
                             'osdi:creator' => { 'href' => person_1_url },
                             'osdi:organizer' => { 'href' => person_2_url }
                           }
                         })
      end

      it 'should include links for both creator and organizer' do
        event = subject.events.create(event_data, creator_person_id: person_1_id, organizer_person_id: person_2_id)

        expect(post_stub).to have_been_requested

        expect(event.action_network_id).to eq '123-456-789-abc'
      end
    end

    context 'no action network id on response' do
      let(:response_body) do
        {
          identifiers: ['somesystem:123'],
          title: 'My Great Event',
          origin_system: 'Some System'
        }.to_json
      end

      it 'should raise' do
        expect do
          subject.events.create(event_data)
        end.to raise_error(ActionNetworkRest::Response::MissingActionNetworkId)

        expect(post_stub).to have_been_requested
      end
    end
  end

  describe '#update' do
    let(:event_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'My Great Event',
        origin_system: 'Some System'
      }
    end
    let(:event_id) { '123-456-789-abc' }
    let(:response_body) do
      {
        identifiers: ['somesystem:123', 'action_network:123-456-789-abc'],
        title: 'My Great Event',
        origin_system: 'Some System'
      }.to_json
    end
    let!(:put_stub) do
      stub_actionnetwork_request("/events/#{event_id}", method: :put, body: event_data)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should PUT event data' do
      updated_event = subject.events.update(event_id, event_data)

      expect(put_stub).to have_been_requested

      expect(updated_event.identifiers).to contain_exactly('action_network:123-456-789-abc',
                                                           'somesystem:123')
    end
  end
end
