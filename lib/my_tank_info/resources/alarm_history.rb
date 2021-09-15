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
  end
end
