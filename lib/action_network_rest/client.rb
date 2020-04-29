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

    def extract_data_from_params(params)
      params.to_json
    end

    ## Helpers to let users do things like `an_client.people.create(params)`

    def entry_point
      @_entry_point ||= ActionNetworkRest::EntryPoint.new(client: self)
    end

    def people
      @_people ||= ActionNetworkRest::People.new(client: self)
    end

    def petitions(petition_id=nil)
      @_petitions ||= ActionNetworkRest::Petitions.new(petition_id, client: self)
    end
  end
end
