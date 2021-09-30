# frozen_string_literal: true

module ActionNetworkRest
  class Signatures < Base
    class CreateError < StandardError; end

    attr_accessor :petition_id

    def base_path
      "petitions/#{url_escape(petition_id)}/signatures/"
    end

    def create(signature_data, tags: [])
      post_body = signature_data
      post_body['add_tags'] = tags if tags.any?

      response = client.post_request(base_path, post_body)
      new_signature = object_from_response(response)

      # Action Network treats the signature create helper endpoint as an unauthenticated
      # "blind" POST (see https://actionnetwork.org/docs/v2/unauthenticated-post/). For this
      # reason they don't return a status code with error to avoid leaking private data. Instead
      # they return 200 OK with an empty body (vs. the newly created signature's data for successful calls)
      raise CreateError if new_signature.empty?

      new_signature
    end

    def update(id, signature_data)
      response = client.put_request("#{base_path}#{url_escape(id)}", signature_data)
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:signatures'
    end
  end
end
