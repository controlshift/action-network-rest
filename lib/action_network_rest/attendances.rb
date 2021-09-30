# frozen_string_literal: true

module ActionNetworkRest
  class Attendances < Base
    class CreateError < StandardError; end

    attr_accessor :event_campaign_id, :event_id

    def base_path
      if event_campaign_id.present?
        "event_campaigns/#{url_escape(event_campaign_id)}/events/#{url_escape(event_id)}/attendances/"
      else
        "events/#{url_escape(event_id)}/attendances/"
      end
    end

    def create(attendance_data)
      response = client.post_request base_path, attendance_data
      new_attendance = object_from_response(response)

      # Action Network treats the attendance create helper endpoint as an unauthenticated
      # "blind" POST (see https://actionnetwork.org/docs/v2/unauthenticated-post/). For this
      # reason they don't return a status code with error to avoid leaking private data. Instead
      # they return 200 OK with an empty body (vs. the newly created attendance's data for successful calls)
      raise CreateError if new_attendance.empty?

      new_attendance
    end

    def update(id, attendance_data)
      response = client.put_request "#{base_path}#{url_escape(id)}", attendance_data
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:attendance'
    end
  end
end
