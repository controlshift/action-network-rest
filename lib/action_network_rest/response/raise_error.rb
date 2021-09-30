# frozen_string_literal: true

module ActionNetworkRest
  module Response
    class RaiseError < Faraday::Response::Middleware
      # rubocop:disable Style/GuardClause
      def on_complete(response)
        status_code = response[:status].to_i

        if (400...600).cover? status_code
          if status_code == 400 && response[:body].include?('error')
            error_hsh = JSON.parse(response[:body])
            error_message = error_hsh['error']

            if error_message == 'You must specify a valid person id'
              raise MustSpecifyValidPersonId, error_message(response)
            end
          elsif status_code == 404
            raise NotFoundError, error_message(response)
          else
            raise ResponseError, error_message(response)
          end
        end
      end
      # rubocop:enable Style/GuardClause

      def error_message(response)
        "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]} \n\n #{response[:body]}"
      end
    end

    class MustSpecifyValidPersonId < StandardError; end

    class NotFoundError < StandardError; end

    class ResponseError < StandardError; end
  end
end
