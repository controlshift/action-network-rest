module ActionNetworkRest
  class EntryPoint < Vertebrae::Model
    def base_path
      ''
    end

    def get
      response = client.get_request base_path
      response.body
    end

    def check_authentication
      response_body = get

      # If we successfully authenticated, the entrypoint response will include a reference to tags.
      # If not (API key missing or wrong), the response will not include anything about tags,
      # but will otherwise be successful.
      authenticated = response_body.dig('_links', 'osdi:tags').present?
      {authenticated_response: authenticated}
    end
  end
end
