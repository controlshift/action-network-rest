# frozen_string_literal: true

module ActionNetworkRest
  class EventCampaigns < Base
    def base_path
      'event_campaigns/'
    end

    def create(event_campaign_data)
      response = client.post_request base_path, event_campaign_data
      object_from_response(response)
    end

    def events
      @_events ||= ActionNetworkRest::Events.new(client: client, event_campaign_id: event_campaign_id)
    end

  end
end
