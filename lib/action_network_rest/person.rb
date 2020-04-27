module ActionNetworkRest
  class Person < Vertebrae::Model
    def base_path
      'people/'
    end

    def get(id)
      client.get_request "#{base_path}#{url_escape(id)}"
    end

    def create(person_data, tags: [])
      post_body = {'person' => person_data}
      if tags.any?
        post_body['add_tags'] = tags
      end

      response = client.post_request base_path, post_body
      response.body
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end
  end
end
