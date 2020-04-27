require 'vertebrae'

module ActionNetworkRest
  extend Vertebrae::Base

  class << self
    def new(options = {})
      ActionNetworkRest::Client.new(options)
    end
  end
end

require "action_network_rest/version"
require "action_network_rest/client"

require 'action_network_rest/person'
