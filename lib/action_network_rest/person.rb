module ActionNetworkRest
  class Person < Vertebrae::Model
    def base_path
      'people'
    end

    def get(id)
      client.get_request "#{base_path}/#{url_escape(id)}"
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end
  end
end
