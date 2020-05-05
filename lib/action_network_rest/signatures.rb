module ActionNetworkRest
  class Signatures < Base
    attr_accessor :petition_id

    def base_path
      "petitions/#{url_escape(petition_id)}/signatures/"
    end

    def create(signature_data, tags: [])
      post_body = signature_data
      if tags.any?
        post_body['add_tags'] = tags
      end

      response = client.post_request base_path, post_body
      response_object = object_from_response(response)

      if response_object[:_links].any? && !response_object[:_links][:'osdi:person'].nil?
        person_href = response_object[:_links][:'osdi:person'][:href]
        people_base_url = action_network_url('/people')
        person_id = person_href.match(%r{#{people_base_url}\/(?<person_id>.+)\Z}).named_captures['person_id']
        response_object.person_id = person_id
      end

      response_object
    end

    def update(id, signature_data)
      response = client.put_request "#{base_path}#{url_escape(id)}", signature_data
      object_from_response(response)
    end
  end
end
