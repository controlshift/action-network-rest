# frozen_string_literal: true

module ActionNetworkRest
  class Events < Base
    attr_accessor :event_campaign_id, :event_id

    def initialize(client:, event_campaign_id: nil, event_id: nil)
      super(client: client, event_id: event_id, event_campaign_id: event_campaign_id)
    end

    def base_path
      if event_campaign_id.present?
        "event_campaigns/#{url_escape(event_campaign_id)}/events/"
      else
        'events/'
      end
    end

    def create(event_data, creator_person_id: nil, organizer_person_id: nil)
      post_body = event_data

      if creator_person_id.present?
        creator_person_url = action_network_url("/people/#{url_escape(creator_person_id)}")
        post_body['_links'] ||= {}
        post_body['_links']['osdi:creator'] = { href: creator_person_url }
      end

      if organizer_person_id.present?
        organizer_person_url = action_network_url("/people/#{url_escape(organizer_person_id)}")
        post_body['_links'] ||= {}
        post_body['_links']['osdi:organizer'] = { href: organizer_person_url }
      end

      response = client.post_request(base_path, post_body)
      object_from_response(response, action_network_id_required: true)
    end

    def attendances
      @_attendances ||= ActionNetworkRest::Attendances.new(client: client, event_id: event_id,
                                                           event_campaign_id: event_campaign_id)
    end

    def update(id, event_data)
      event_path = "#{base_path}#{url_escape(id)}"
      response = client.put_request event_path, event_data
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:events'
    end
  end
end
