# frozen_string_literal: true

module MyTankInfo
  class AlarmsResource < Resource
    def list(**params)
      response = get("api/alarms", params: params)
      Collection.from_response(response, type: Alarm)
    end
  end
end
