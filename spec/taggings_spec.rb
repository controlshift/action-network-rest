require 'spec_helper'

describe ActionNetworkRest::Taggings do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:tag_id) { '71f8feef-61c8-4e6b-9745-ec1d7752f298' }
    let(:tagging_id) { '82e909f9-1ac7-4952-bbd4-b4690a14bec2' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{tagging_id}"],
        _links: {
          'osdi:person' => {
            href: 'https://actionnetwork.org/api/v2/people/82e909f9-1ac7-4952-bbd4-b4690a14bec2'
          },
          'osdi:tag' => {
            href: "https://actionnetwork.org/api/v2/tags/#{tag_id}"
          }
        }
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/tags/#{tag_id}/taggings/#{tagging_id}", method: :get)
        .to_return(status: 200, body: response_body)
    end

    it 'should retrieve tagging data' do
      tagging = subject.tags(tag_id).taggings.get(tagging_id)
      expect(tagging.action_network_id).to eq tagging_id
    end
  end
end
