# frozen_string_literal: true

module ActionNetworkRest
  class Base < Vertebrae::Model
    def get(id)
      response = client.get_request "#{base_path}#{url_escape(id)}"
      object_from_response(response)
    end

    def list(page: 1)
      response = client.get_request "#{base_path}?page=#{url_escape(page)}"
      objects = response.body.dig('_embedded', osdi_key)
      return [] if objects.nil?

      objects.each { |obj| set_action_network_id_on_object(obj) }

      objects
    end

    def all
      min_wait = 0.25 # sec to wait between calls
      timestamp = Time.now.to_r # secs since Unix Epoch
      page_number = 1
      tries = 0
      all = []
      loop do
        # Limit rate before request to avoid error
        wait = min_wait * (1.5**tries)
        new_time = Time.now.to_r
        if (timestamp + min_wait - new_time).positive?
          sleep(wait) # Wait if calling again could excede the rate limit
          tries += 1
          next # check again
        end

        begin
          page = list(page: page_number)
        rescue ActionNetworkRest::Response::TooManyRequests
          if tries >= 10
            raise ActionNetworkRest::Response::UsedAllRequestTries,
                  {
                    tries: tries,
                    last_wait_length: wait,
                    resource: base_path
                  }.to_json
          end

          sleep(wait)
          tries += 1 # Exponential back off if got Too Many Requests error reponse
          next
        end
        timestamp = Time.now.to_i

        break if page.empty?

        all.concat(page)
        page_number += 1
        tries = 0
      end
      all
    end

    private

    def url_escape(string)
      CGI.escape(string.to_s)
    end

    def set_action_network_id_on_object(obj, action_network_id_required: false)
      # Takes an object which may contain an `identifiers` key, which may contain an action_network identifier
      # If so, we pull out the action_network identifier and stick it in a top-level key "action_network_id",
      # for the convenience of callers using the returned object.
      # "identifiers": [
      #   "action_network:d6bdf50e-c3a4-4981-a948-3d8c086066d7",
      #   "some_external_system:1",
      #   "another_external_system:57"
      # ]
      identifiers = obj[:identifiers] || []
      qualified_actionnetwork_id = identifiers.find do |id|
        id.split(':').first == 'action_network'
      end
      if qualified_actionnetwork_id.present?
        obj.action_network_id = qualified_actionnetwork_id.sub(/^action_network:/, '')
      elsif action_network_id_required
        raise ActionNetworkRest::Response::MissingActionNetworkId, obj.inspect
      end

      obj
    end

    def object_from_response(response, action_network_id_required: false)
      obj = response.body
      set_action_network_id_on_object(obj, action_network_id_required: action_network_id_required)
    end

    def action_network_url(path)
      client.connection.configuration.endpoint + path
    end
  end
end
