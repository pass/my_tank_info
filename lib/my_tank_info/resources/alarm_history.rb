# frozen_string_literal: true

module MyTankInfo
  class AlarmHistoryResource < Resource
    def list(site_id: nil, **params)
      response =
        if site_id.nil?
          get_request("api/alarmhistory", params: params)
        else
          get_request("api/sites/#{site_id}/alarmhistory", params: params)
        end

      Collection.from_response(response, type: Alarm)
    end

    def list_notes(alarm_id:)
      response = get_request("api/alarmhistory/#{alarm_id}/notes")
      Collection.from_response(response, type: AlarmNote)
    end

    def retrieve(alarm_id:)
      Alarm.new get_request("api/alarmhistory/#{alarm_id}").body
    end
  end
end
