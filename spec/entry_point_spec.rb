# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::EntryPoint do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:response_body) { { some: 'data' }.to_json }

    before :each do
      stub_actionnetwork_request('/', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    it 'should return the response' do
      expect(subject.entry_point.get).to eq({ 'some' => 'data' })
    end
  end

  describe '#authenticated_successfully?' do
    before :each do
      stub_actionnetwork_request('/', method: :get)
        .to_return(status: 200, body: response_body, headers: { content_type: 'application/json' })
    end

    context 'response includes tags' do
      let(:response_body) do
        {
          motd: 'Welcome!',
          _links: {
            'osdi:petitions' => {
              title: 'some petitions',
              href: 'https://actionnetwork.org/api/v2/petitions'
            },
            'osdi:tags' => {
              title: 'your tags',
              href: 'https://actionnetwork.org/api/v2/tags'
            }
          }
        }.to_json
      end

      it 'should return true' do
        expect(subject.entry_point.authenticated_successfully?).to be_truthy
      end
    end

    context 'response does not include tags' do
      let(:response_body) do
        {
          motd: 'Welcome!',
          _links: {
            'osdi:petitions' => {
              title: 'some petitions',
              href: 'https://actionnetwork.org/api/v2/petitions'
            }
          }
        }.to_json
      end

      it 'should return false' do
        expect(subject.entry_point.authenticated_successfully?).to be_falsey
      end
    end
  end
end
