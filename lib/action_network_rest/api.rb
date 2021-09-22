# frozen_string_literal: true

module ActionNetworkRest
  class API < Vertebrae::API
    def setup
      connection.stack do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded

        builder.use Faraday::Response::Logger if ENV['DEBUG']

        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseJson

        builder.use ActionNetworkRest::Response::RaiseError
        builder.adapter connection.configuration.adapter
      end
    end
  end
end
