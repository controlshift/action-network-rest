module ActionNetworkRest
  class People < Base
    def base_path
      'people/'
    end

    def create(person_data, tags: [])
      post_body = {'person' => person_data}
      if tags.any?
        post_body['add_tags'] = tags
      end

      response = client.post_request base_path, post_body
      object_from_response(response)
    end

    def unsubscribe(id)
      request_body = {email_addresses: [{status: 'unsubscribed'}]}
      response = client.put_request "#{base_path}#{url_escape(id)}", request_body
      object_from_response(response)
    end

    def find_id_by_email(email)
      url_encoded_filter_string = url_escape("email_address eq '#{email}'")
      response = client.get_request "#{base_path}?filter=#{url_encoded_filter_string}"
      person_action_network_id_from_query_response(response)
    end

    private

    def person_action_network_id_from_query_response(response)
      # This works for parsing exactly 1 person's info out of the response.
      # The response we get from Action Network is expected to have
      #
      # "_embedded": {
      #   "osdi:people": [{
      #       "identifiers": [
      #           "action_network:c947bcd0-929e-11e3-a2e9-12313d316c29"
      #            ....
      #        ]
      #    }]
      # }
      #
      # If so, we pull out the action_network identifier and return it
      identifiers = response.body[:_embedded]['osdi:people'].first[:identifiers] || []
      qualified_actionnetwork_id = identifiers.find do |id|
        id.split(':').first == 'action_network'
      end

      if qualified_actionnetwork_id.present?
        qualified_actionnetwork_id.sub(/^action_network:/, '')
      end
    end
  end
end
