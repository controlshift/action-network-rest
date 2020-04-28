module ActionNetworkRest
  class Base < Vertebrae::Model
    def get(id)
      response = client.get_request "#{base_path}#{url_escape(id)}"
      response.body
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end
  end
end
