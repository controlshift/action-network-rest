# frozen_string_literal: true

module ActionNetworkRest
  class Campaigns < Base
    attr_accessor :campaign_id

    def initialize(client:)
      super(client: client)
    end

    def base_path
      'campaigns/'
    end

    private

    def osdi_key
      'action_network:campaigns'
    end
  end
end
