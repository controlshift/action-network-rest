# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Events do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:response_body) { { some: 'data' }.to_json }

    before :each do
      stub_actionnetwork_request('/events/123', method: :get).to_return(status: 200, body: response_body)
    end

    it 'should return the response' do
      expect(subject.events.get(123)).to eq({ 'some' => 'data' })
    end
  end

  describe '#list' do
    let(:response_body) { fixture('events/list.json') }

    it 'should return the response' do
      stub_actionnetwork_request('/events/?page=1', method: :get).to_return(status: 200, body: response_body)

      expect(subject.events.list.length).to eq(2)
      expect(subject.events.list.first).to include({ 'action_network_id' => '8a625981-67a4-4457-8b55-2e30b267b2c2' })
    end

    it 'should support event_campaign listing' do
      stub_request = stub_actionnetwork_request('/event_campaigns/foo/events/?page=1',
                                                method: :get).to_return(status: 200, body: response_body)

      subject.event_campaigns('foo').events.list

      expect(stub_request).to have_been_requested
    end

    it 'should paginate' do
      stub_request = stub_actionnetwork_request('/events/?page=2', method: :get).to_return(status: 200,
                                                                                           body: response_body)
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
        .to_return(status: 200, body: response_body)
    end

    it 'should POST event data' do
      event = subject.events.create(event_data)

      expect(post_stub).to have_been_requested

      expect(event.identifiers).to contain_exactly('action_network:123-456-789-abc',
                                                   'somesystem:123')
      expect(event.action_network_id).to eq '123-456-789-abc'
    end
  end
end
