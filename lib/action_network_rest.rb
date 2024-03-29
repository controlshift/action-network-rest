# frozen_string_literal: true

require 'vertebrae'

module ActionNetworkRest
  extend Vertebrae::Base

  class << self
    def new(options = {})
      ActionNetworkRest::Client.new(options)
    end
  end
end

require 'action_network_rest/version'
require 'action_network_rest/api'
require 'action_network_rest/response/raise_error'
require 'action_network_rest/client'
require 'action_network_rest/base'

require 'action_network_rest/advocacy_campaigns'
require 'action_network_rest/attendances'
require 'action_network_rest/campaigns'
require 'action_network_rest/entry_point'
require 'action_network_rest/events'
require 'action_network_rest/event_campaigns'
require 'action_network_rest/forms'
require 'action_network_rest/people'
require 'action_network_rest/petitions'
require 'action_network_rest/signatures'
require 'action_network_rest/taggings'
require 'action_network_rest/tags'
