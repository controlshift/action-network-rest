# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Events do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:response_body) { { some: 'data' }.to_json }

    before :each do
      stub_actionnetwork_request('/event_campaigns/123', method: :get).to_return(status: 200, body: response_body)
    end

    it 'should return the response' do
      expect(subject.event_campaigns.get(123)).to eq({ 'some' => 'data' })
    end
  end

  describe '#list' do
    let(:response_body) { fixture('event_campaigns/list.json') }

    it 'should return the response' do
      stub_actionnetwork_request('/event_campaigns/?page=1', method: :get).to_return(status: 200, body: response_body)

      expect(subject.event_campaigns.list.length).to eq(2)
      expect(subject.event_campaigns.list.first).to include({
                                                              'action_network_id' => '874e7e97-973d-4683-b992-61e1ca120710',
                                                              'title' => 'House parties to help us win!'
                                                            })
    end

    it 'should paginate' do
      stub_request = stub_actionnetwork_request('/event_campaigns/?page=2', method: :get).to_return(status: 200, body: response_body)
      subject.event_campaigns.list(page: 2)
      expect(stub_request).to have_been_requested
    end
  end
end
