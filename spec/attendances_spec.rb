# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Attendances do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#create' do
    let(:event_id) { 'abc-def-123-456' }
    let(:attendance_data) do
      {
        identifiers: ['some_system:123'],
        person: {
          given_name: 'Isaac',
          family_name: 'Asimov',
          postal_addresses: [{ postal_code: '12345' }],
          email_addresses: [{ address: 'asimov@example.com' }]
        }
      }
    end
    let(:request_body) { attendance_data }
    let(:attendance_id) { '789-ghi-321-jkl' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{attendance_id}"],
        'action_network:person_id' => '699da712-929f-11e3-a2e9-12313d316c29',
        'action_network:event_id' => event_id
      }.to_json
    end

    let!(:post_stub) do
      stub_actionnetwork_request("/events/#{event_id}/attendances/", method: :post, body: request_body)
        .to_return(status: 200, body: response_body)
    end

    it 'should POST signature data' do
      attendance = subject.events(event_id).attendances.create(attendance_data)

      expect(post_stub).to have_been_requested

      expect(attendance.action_network_id).to eq(attendance_id)
    end

    # Action Network treats the attendance create helper endpoint as an unauthenticated
    # "blind" POST (see https://actionnetwork.org/docs/v2/unauthenticated-post/). For this
    # reason they don't return a status code with error to avoid leaking private data. Instead
    # they return 200 OK with an empty body (vs. the newly created attendance's data for successful calls)
    context 'response body is empty' do
      let(:response_body) { {}.to_json }

      it 'should raise error' do
        expect { subject.events(event_id).attendances.create(attendance_data) }.to raise_error(ActionNetworkRest::Attendances::CreateError)
      end
    end

    context 'when part of an event campaign' do
      let(:event_campaign_id) { 'abc123' }

      let!(:post_stub) do
        stub_actionnetwork_request("/event_campaigns/#{event_campaign_id}/events/#{event_id}/attendances/",
                                   method: :post, body: request_body)
          .to_return(status: 200, body: response_body)
      end

      it 'should POST signature data to the prefixed path' do
        attendance = subject.event_campaigns(event_campaign_id).events(event_id).attendances.create(attendance_data)

        expect(post_stub).to have_been_requested

        expect(attendance.action_network_id).to eq(attendance_id)
      end
    end
  end
end
