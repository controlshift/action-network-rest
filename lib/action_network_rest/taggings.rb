module ActionNetworkRest
  class Taggings < Base
    attr_accessor :tag_id

    def base_path
      "tags/#{url_escape(tag_id)}/taggings/"
    end

    def create(tagging_data, person_id:)
      post_body = tagging_data
      person_url = action_network_url("/people/#{url_escape(person_id)}")
      post_body['_links'] = {'osdi:person' => {href: person_url}}

      response = client.post_request base_path, post_body
      object_from_response(response)
    end

    def delete(id)
      response = client.delete_request "#{base_path}#{url_escape(id)}"
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:taggings'
    end
  end
end
