# frozen_string_literal: true

module MyTankInfo
  class TankRunoutResource < Resource
    def list(tank_id:)
      response = get_request("api/tanks/#{tank_id}/runout")
      Collection.from_response(response, type: TankRunoutRecord)
    end
  end
end
