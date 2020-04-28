module ActionNetworkRest
  class EntryPoint < Vertebrae::Model
    def base_path
      ''
    end

    def get
      response = client.get_request base_path
      response.body
    end

    def authenticated_successfully?
      response_body = get

      # If we successfully authenticated, the entrypoint response will include a reference to tags.
      # If not (API key missing or wrong), the response will not include anything about tags,
      # but will otherwise be successful.
      response_body.dig('_links', 'osdi:tags').present?
    end
  end
end
