# frozen_string_literal: true

module MyTankInfo
  class TankDailyUsageResource < Resource
    def list(tank_id:)
      response = get_request("api/tanks/#{tank_id}/dailyusage")
      Collection.from_response(response, type: TankDailyUsageRecord)
    end
  end
end
