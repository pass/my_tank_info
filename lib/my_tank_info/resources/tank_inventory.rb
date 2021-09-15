# frozen_string_literal: true

module MyTankInfo
  class TankInventoryResource < Resource
    def list(tank_id:, **params)
      response = get("api/tanks/#{tank_id}/inventory", params: params)
      Collection.from_response(response, type: TankInventoryRecord)
    end
  end
end
