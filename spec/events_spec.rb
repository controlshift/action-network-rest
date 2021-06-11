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
end

