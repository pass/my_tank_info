# frozen_string_literal: true

module MyTankInfo
  class TankDeliveriesResource < Resource
    def list(tank_id:, **params)
      response = get("api/tanks/#{tank_id}/deliveries", params: params)
      Collection.from_response(response, type: TankDeliveryRecord)
    end
  end
end
