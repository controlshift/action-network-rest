# frozen_string_literal: true

module ActionNetworkRest
  class People < Base
    def base_path
      'people/'
    end

    def create(person_data, tags: [])
      post_body = { 'person' => person_data }
      post_body['add_tags'] = tags if tags.any?

      response = client.post_request base_path, post_body
      object_from_response(response)
    end

    def unsubscribe(id)
      request_body = { email_addresses: [{ status: 'unsubscribed' }] }
      response = client.put_request "#{base_path}#{url_escape(id)}", request_body
      object_from_response(response)
    end

    def find_by_email(email)
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
      url_encoded_filter_string = url_escape("email_address eq '#{email}'")
      response = client.get_request "#{base_path}?filter=#{url_encoded_filter_string}"
      person_object = response.body[:_embedded][osdi_key].first
      set_action_network_id_on_object(person_object) if person_object.present?
    end

    def find_by_phone_number(phone_number)
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
      url_encoded_filter_string = url_escape("phone_number eq '#{phone_number}'")
      response = client.get_request "#{base_path}?filter=#{url_encoded_filter_string}"
      person_object = response.body[:_embedded][osdi_key].first
      set_action_network_id_on_object(person_object) if person_object.present?
    end

    def update(id, person_data)
      people_path = "#{base_path}#{url_escape(id)}"
      response = client.put_request people_path, person_data
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:people'
    end
  end
end
