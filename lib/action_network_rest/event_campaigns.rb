# frozen_string_literal: true

module ActionNetworkRest
  class EventCampaigns < Base
    attr_accessor :event_campaign_id

    # Without a event_campaign_id, this class is used for EventCampaign creation/update endpoints.
    # With a event_campaign_id, this class is used to initialise the Events class,
    # like client.event_campaigns(123).events
    def initialize(event_campaign_id = nil, client:)
      super(client: client, event_campaign_id: event_campaign_id)
    end

    def base_path
      'event_campaigns/'
    end

    def create(event_campaign_data)
      response = client.post_request(base_path, event_campaign_data)
      object_from_response(response)
    end

    def events(event_id = nil)
      @_events ||= ActionNetworkRest::Events.new(event_campaign_id: event_campaign_id, event_id: event_id, client: client)
    end

    private

    def osdi_key
      'action_network:event_campaigns'
    end

  end
end
