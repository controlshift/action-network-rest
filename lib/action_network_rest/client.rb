# frozen_string_literal: true

module ActionNetworkRest
  class Client < API
    attr_accessor :api_key

    def initialize(options = {}, &block)
      self.api_key = options[:api_key]
      super(options, &block)
    end

    def default_options
      {
        host: 'actionnetwork.org',
        prefix: '/api/v2',
        content_type: 'application/json',
        additional_headers: { 'OSDI-API-Token' => api_key },
        user_agent: 'ruby: ActionNetworkRest'
      }
    end

    def extract_data_from_params(params)
      params.to_json
    end

    ## Helpers to let users do things like `an_client.people.create(params)`

    def events(event_id = nil)
      if @_events&.send(:[], event_id).nil?
        @_events = {} if @_events.nil?

        @_events[event_id] = ActionNetworkRest::Events.new(event_id: event_id, client: self)
      end

      @_events[event_id]
    end

    def event_campaigns(event_campaign_id = nil)
      if @_event_campaigns&.send(:[], event_campaign_id).nil?
        @_event_campaigns = {} if @_event_campaigns.nil?

        @_event_campaigns[event_campaign_id] = ActionNetworkRest::EventCampaigns.new(event_campaign_id, client: self)
      end

      @_event_campaigns[event_campaign_id]
    end

    def entry_point
      @_entry_point ||= ActionNetworkRest::EntryPoint.new(client: self)
    end

    def people
      @_people ||= ActionNetworkRest::People.new(client: self)
    end

    def petitions(petition_id = nil)
      if @_petitions&.send(:[], petition_id).nil?
        @_petitions = {} if @_petitions.nil?

        @_petitions[petition_id] = ActionNetworkRest::Petitions.new(petition_id, client: self)
      end

      @_petitions[petition_id]
    end

    def tags(tag_id = nil)
      if @_tags&.send(:[], tag_id).nil?
        @_tags = {} if @_tags.nil?

        @_tags[tag_id] = ActionNetworkRest::Tags.new(tag_id, client: self)
      end

      @_tags[tag_id]
    end
  end
end
