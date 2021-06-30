# frozen_string_literal: true

module ActionNetworkRest
  class Events < Base
    attr_accessor :event_campaign_id, :event_id

    def initialize(event_campaign_id: nil, event_id: nil, client:)
      super(client: client, event_id: event_id, event_campaign_id: event_campaign_id)
    end

    def base_path
      if event_campaign_id.present?
        "event_campaigns/#{url_escape(event_campaign_id)}/events/"
      else
        'events/'
      end
    end

    def create(event_data)
      response = client.post_request(base_path, event_data)
      object_from_response(response)
    end

    def attendances
      @_attendances ||= ActionNetworkRest::Attendances.new(client: client, event_id: event_id,
                                                           event_campaign_id: event_campaign_id)
    end

    private

    def osdi_key
      'osdi:events'
    end
  end
end
