module ActionNetworkRest
  class Tags < Base
    def base_path
      'tags/'
    end

    def create(name)
      post_body = {name: name}
      response = client.post_request base_path, post_body
      object_from_response(response)
    end
  end
end
