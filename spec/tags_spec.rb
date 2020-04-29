require 'spec_helper'

describe ActionNetworkRest::Tags do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:tag_id) { '71f8feef-61c8-4e6b-9745-ec1d7752f298' }
    let(:tag_name) { 'Volunteers' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{tag_id}"],
        name: tag_name
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/tags/#{tag_id}", method: :get)
        .to_return(status: 200, body: response_body)
    end

    it 'should retrieve tag data' do
      tag = subject.tags.get(tag_id)
      expect(tag.name).to eq tag_name
    end
  end

  describe '#create' do
    let(:tag_name) { 'Volunteers' }
    let(:request_body) { {name: tag_name} }
    let(:tag_id) { '71f8feef-61c8-4e6b-9745-ec1d7752f298' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{tag_id}"],
        name: tag_name
      }.to_json
    end
    let!(:post_stub) do
      stub_actionnetwork_request('/tags/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body)
    end

    it 'should POST tag' do
      tag = subject.tags.create(tag_name)

      expect(post_stub).to have_been_requested

      expect(tag.action_network_id).to eq tag_id
    end
  end
end
