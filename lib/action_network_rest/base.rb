# frozen_string_literal: true

module ActionNetworkRest
  class Base < Vertebrae::Model
    def get(id)
      response = client.get_request "#{base_path}#{url_escape(id)}"
      object_from_response(response)
    end

    def list(page: 1)
      response = client.get_request "#{base_path}?page=#{url_escape(page)}"
      objects = response.body.dig('_embedded', osdi_key)
      return [] if objects.nil?

      objects.each { |obj| set_action_network_id_on_object(obj) }

      objects
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end

    def set_action_network_id_on_object(obj)
      # Takes an object which may contain an `identifiers` key, which may contain an action_network identifier
      # If so, we pull out the action_network identifier and stick it in a top-level key "action_network_id",
      # for the convenience of callers using the returned object.
      # "identifiers": [
      #   "action_network:d6bdf50e-c3a4-4981-a948-3d8c086066d7",
      #   "some_external_system:1",
      #   "another_external_system:57"
      # ]
      identifiers = obj[:identifiers] || []
      qualified_actionnetwork_id = identifiers.find do |id|
        id.split(':').first == 'action_network'
      end
      if qualified_actionnetwork_id.present?
        obj.action_network_id = qualified_actionnetwork_id.sub(/^action_network:/, '')
      end

      obj
    end

    def object_from_response(response)
      obj = response.body
      set_action_network_id_on_object(obj)
    end

    def action_network_url(path)
      client.connection.configuration.endpoint + path
    end
  end
end
