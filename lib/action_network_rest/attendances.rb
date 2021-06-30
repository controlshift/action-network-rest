# frozen_string_literal: true

module ActionNetworkRest
  class Attendances < Base
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
      object_from_response(response)
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
