module ActionNetworkRest
  class Client < Vertebrae::API
    attr_accessor :api_key

    def initialize(options={}, &block)
      self.api_key = options[:api_key]
      super(options={}, &block)
    end

    def default_options
      {
        host: 'actionnetwork.org',
        prefix: '/api/v2',
        content_type: 'application/json',
        additional_headers: {'OSDI-API-Token' => api_key},
        user_agent: 'ruby: ActionNetworkRest'
      }
    end
  end
end
