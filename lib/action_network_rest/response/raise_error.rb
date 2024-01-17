# frozen_string_literal: true

module ActionNetworkRest
  module Response
    class RaiseError < Faraday::Middleware
      def on_complete(response)
        status_code = response[:status].to_i
        return unless (400...600).cover?(status_code)

        raise error_class_for(status_code, response), error_message(response)
      end

      def error_message(response)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]} \n\n #{response[:body]}"
      end

      private

      def error_class_for(status_code, response)
        case status_code
        when 400 then bad_request_error_class(response)
        when 403 then AuthorizationError
        when 404 then NotFoundError
        when 429 then TooManyRequests
        when 500..599 then ServerError
        else ResponseError
        end
      end

      def bad_request_error_class(response)
        return ResponseError unless response[:body].include?('error')

        # A few specific 400 messages map to a dedicated exception; any other
        # 400 still raises the generic ResponseError.
        body_error = JSON.parse(response[:body])['error']
        body_error == 'You must specify a valid person id' ? MustSpecifyValidPersonId : ResponseError
      end
    end

    class AuthorizationError < StandardError; end

    class MissingActionNetworkId < StandardError; end

    class MustSpecifyValidPersonId < StandardError; end

    class NotFoundError < StandardError; end

    class ResponseError < StandardError; end

    # Raised for 5xx responses. Subclasses ResponseError so existing rescues
    # continue to catch server errors while allowing callers to distinguish
    # transient server-side failures (worth retrying) from client errors.
    class ServerError < ResponseError; end

    class TooManyRequests < StandardError; end

    class UsedAllRequestTries < StandardError; end
  end
end

Faraday::Response.register_middleware actionnetwork_raise_error: -> { ActionNetworkRest::Response::RaiseError }
