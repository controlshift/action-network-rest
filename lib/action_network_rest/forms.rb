# frozen_string_literal: true

module ActionNetworkRest
  class Forms < Base
    def initialize(client:)
      super(client: client)
    end

    def base_path
      'forms/'
    end

    def create(form_data)
      post_data = form_data

      response = client.post_request(base_path, post_data)
      object_from_response(response, action_network_id_required: true)
    end

    def update(form_id, form_data)
      put_data = form_data

      response = client.put_request("#{base_path}#{form_id}", put_data)
      object_from_response(response, action_network_id_required: true)
    end

    private

    def osdi_key
      'osdi:forms'
    end
  end
end
