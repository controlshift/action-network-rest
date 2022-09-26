# frozen_string_literal: true

module ActionNetworkRest
  class AdvocacyCampaigns < Base
    def initialize(client:)
      super(client: client)
    end

    def base_path
      'advocacy_campaigns/'
    end

    def create(advocacy_campaign_data)
      post_body = advocacy_campaign_data
      puts base_path
      response = client.post_request(base_path, post_body)
      object_from_response(response, action_network_id_required: true)
    end

    def update(advocacy_campaign_id, advocacy_campaign_data)
      put_body = advocacy_campaign_data

      response = client.put_request("#{base_path}#{advocacy_campaign_id}", put_body)
      object_from_response(response, action_network_id_required: true)
    end

    private

    def osdi_key
      'osdi:advocacy_campaigns'
    end
  end
end
