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
      object_from_response(response)
    end

    def update(id, signature_data)
      response = client.put_request "#{base_path}#{url_escape(id)}", signature_data
      object_from_response(response)
    end
  end
end
