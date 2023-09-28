# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::EventCampaigns do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:response_body) { { some: 'data' }.to_json }

    before :each do
      stub_actionnetwork_request('/event_campaigns/123', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should return the response' do
      expect(subject.event_campaigns.get(123)).to eq({ 'some' => 'data' })
    end
  end

  describe '#list' do
    let(:response_body) { fixture('event_campaigns/list.json') }

    it 'should return the response' do
      stub_actionnetwork_request('/event_campaigns/?page=1', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })

      expect(subject.event_campaigns.list.length).to eq(2)
      expect(subject.event_campaigns.list.first)
        .to include({ 'action_network_id' => '874e7e97-973d-4683-b992-61e1ca120710',
                      'title' => 'House parties to help us win!' })
    end

    it 'should paginate' do
      stub_request = stub_actionnetwork_request('/event_campaigns/?page=2', method: :get)
                     .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
      subject.event_campaigns.list(page: 2)
      expect(stub_request).to have_been_requested
    end
  end

  describe '#update' do
    let(:campaign_data) do
      {
        identifiers: ['somesystem:123'],
        title: 'My Great Event Campaign',
        origin_system: 'Some System'
      }
    end
    let(:campaign_id) { '2df5eb21-535a-433e-8440-a8a3f2107643' }
    let(:response_body) do
      {
        identifiers: ['somesystem:123', "action_network:#{campaign_id}"],
        title: 'My Great Event Campaign',
        origin_system: 'Some System'
      }.to_json
    end
    let!(:put_stub) do
      stub_actionnetwork_request("/event_campaigns/#{campaign_id}", method: :put, body: campaign_data)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should PUT event campaign data' do
      updated_event_campaign = subject.event_campaigns.update(campaign_id, campaign_data)

      expect(put_stub).to have_been_requested

      expect(updated_event_campaign.identifiers).to contain_exactly("action_network:#{campaign_id}",
                                                                    'somesystem:123')
    end
  end
end
