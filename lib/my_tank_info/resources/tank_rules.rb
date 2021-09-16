# frozen_string_literal: true

module MyTankInfo
  class TankRulesResource < Resource
    def list(tank_id:)
      response = get_request("/api/tanks/#{tank_id}/rules")
      Collection.from_response(response, type: TankRule)
    end

    def update(tank_id:, attributes:)
      response = put_request("api/tanks/#{tank_id}/rules", body: attributes)
      Collection.from_response(response, type: TankRule)
    end
  end
end
