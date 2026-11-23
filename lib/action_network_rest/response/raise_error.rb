# frozen_string_literal: true

module ActionNetworkRest
  module Response
    class RaiseError < Faraday::Middleware
      def on_complete(response)
        status_code = response[:status].to_i
        raise error_class_for(status_code, response), error_message(response) if (400...600).cover?(status_code)
        raise UnexpectedResponseFormat, unexpected_format_message(response) if unparsed_body?(response)
      end

      def error_message(response)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]} \n\n #{response[:body]}"
      end

      private

      # The JSON middleware only parses JSON content types, so a success status
      # carrying anything else (e.g. an HTML maintenance page) arrives as a raw
      # String that callers would otherwise index as if it were a Hash.
      def unparsed_body?(response)
        body = response[:body]
        body.is_a?(String) && !body.strip.empty? && !content_type(response).match?(/\bjson\b/)
      end

      def unexpected_format_message(response)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]} with non-JSON " \
          "content-type #{content_type(response).inspect} \n\n #{response[:body][0, 500]}"
      end

      def content_type(response)
        (response[:response_headers] || {})['content-type'].to_s
      end

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

    # Raised when a success response has a body that isn't JSON, which happens
    # when Action Network serves an error or maintenance page with a 2xx status.
    class UnexpectedResponseFormat < ServerError; end

    class TooManyRequests < StandardError; end

    class UsedAllRequestTries < StandardError; end
  end
end

Faraday::Response.register_middleware actionnetwork_raise_error: -> { ActionNetworkRest::Response::RaiseError }
