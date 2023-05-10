# frozen_string_literal: true

module ActionNetworkRest
  class API < Vertebrae::API
    def setup
      connection.faraday_connection = Faraday.new(connection.configuration.faraday_options) do |f|
        f.request :multipart
        f.request :url_encoded

        f.response :mashify
        f.response :json

        f.response :actionnetwork_raise_error
        f.adapter connection.configuration.adapter
      end
    end
  end
end
