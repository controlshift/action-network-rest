require 'spec_helper'

describe ActionNetworkRest::Person do
  subject { ActionNetworkRest.new(api_key: 'secret_key') }

  describe '#get' do
    let(:person_id) { 'abc-def-123-456' }
    let(:status) { 200 }
    let(:response_body) do
      {
        identifiers: ["action_network:#{person_id}"],
        email_addresses: [
          {
            primary: true,
            address: 'jane@example.com',
            status: 'subscribed'
          }
        ]
      }.to_json
    end

    before :each do
      stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_id}")
        .to_return(status: status, body: response_body)
    end

    it 'should retrieve person data' do
      person = subject.person.get(person_id).body
      expect(person.email_addresses.first.address).to eq 'jane@example.com'
    end
  end
end
