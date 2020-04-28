module ActionNetworkRest
  class Base < Vertebrae::Model
    def get(id)
      response = client.get_request "#{base_path}#{url_escape(id)}"
      object_from_response(response)
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end

    def object_from_response(response)
      obj = response.body

      # The response we get from Action Network may contain an "identifiers" block that looks something like:
      #
      # "identifiers": [
      #   "action_network:d6bdf50e-c3a4-4981-a948-3d8c086066d7",
      #   "some_external_system:1",
      #   "another_external_system:57"
      # ]
      #
      # If so, we pull out the action_network identifier and stick it in a top-level key "action_network_id",
      # for the convenience of callers using the returned object.
      identifiers = obj[:identifiers] || []
      qualified_actionnetwork_id = identifiers.find do |id|
        id.split(':').first == 'action_network'
      end
      if qualified_actionnetwork_id.present?
        obj.action_network_id = qualified_actionnetwork_id.sub(/^action_network:/, '')
      end

      obj
    end

    def action_network_url(path)
      client.connection.configuration.endpoint + path
    end
  end
end
