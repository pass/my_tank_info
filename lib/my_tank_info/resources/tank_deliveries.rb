# frozen_string_literal: true

module MyTankInfo
  class TankDeliveriesResource < Resource
    def list(tank_id:, **params)
      response = get_request("api/tanks/#{tank_id}/deliveries", params: params)
      Collection.from_response(response, type: TankDeliveryRecord)
    end

    def update(tank_id:, delivery_id:, **attributes)
      required_attributes = [
        :start_date_and_time,
        :start_gross,
        :stop_date_and_time,
        :stop_gross,
        :delivery_net,
        :delivery_gross,
        :bol_number
      ]

      enforce_required_attributes(required_attrs: required_attributes, attrs: attributes)

      request = put_request("api/tanks/#{tank_id}/deliveries/#{delivery_id}", body: attributes)
      TankDeliveryRecord.new request.body
    end
  end
end
