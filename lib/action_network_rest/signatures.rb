module ActionNetworkRest
  class Signatures < Base
    def get(petition_id:, id:)
      response = client.get_request "petitions/#{url_escape(petition_id)}/signatures/#{url_escape(id)}"
      object_from_response(response)
    end
  end
end
