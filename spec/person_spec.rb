require 'spec_helper'

describe ActionNetworkRest::Person do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

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
      person = subject.person.get(person_id)
      expect(person.email_addresses.first.address).to eq 'jane@example.com'
    end
  end

  describe '#create' do
    let(:person_data) do
      {
        given_name: 'Alan',
        family_name: 'Turing',
        email_addresses: [{address: 'alan@example.com'}]
      }
    end
    let(:request_body) { { person: person_data } }
    let(:response_body) do
      {
        identifiers: ["action_network:123-456-789"],
      }.to_json
    end

    let!(:post_stub) do
      stub_request(:post, 'https://actionnetwork.org/api/v2/people/')
        .with(body: request_body, headers: {'OSDI-API-Token' => api_key})
        .to_return(status: 200, body: response_body)
    end

    it 'should POST person data' do
      person = subject.person.create(person_data)

      expect(post_stub).to have_been_requested

      expect(person.identifiers).to contain_exactly('action_network:123-456-789')
    end

    context 'with tags' do
      let(:request_body) do
        {
          add_tags: ['foo', 'bar'],
          person: person_data
        }
      end

      it 'should include tags in post' do
        person = subject.person.create(person_data, tags: ['foo', 'bar'])

        expect(post_stub).to have_been_requested

        expect(person.identifiers).to contain_exactly('action_network:123-456-789')
      end
    end
  end
end
