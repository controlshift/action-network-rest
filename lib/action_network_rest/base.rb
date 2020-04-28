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
