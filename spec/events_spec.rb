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
end
