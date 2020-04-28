module ActionNetworkRest
  class Signatures < Base
    def get(petition_id:, id:)
      response = client.get_request "petitions/#{url_escape(petition_id)}/signatures/#{url_escape(id)}"
      object_from_response(response)
    end

    def create(petition_id:, signature_data:, person_data:, tags: [])
      post_body = signature_data.merge(person: person_data)
      if tags.any?
        post_body['add_tags'] = tags
      end

      response = client.post_request "petitions/#{url_escape(petition_id)}/signatures/", post_body
      object_from_response(response)
    end
  end
end
