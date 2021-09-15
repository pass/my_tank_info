# frozen_string_literal: true

module MyTankInfo
  class ActiveAlarmsResource < Resource
    def list(site_id: nil, **params)
      response = get("api/alarms", params: params)

      if site_id.nil?
        Collection.from_response(response, type: Alarm)
      else
        Collection.from_response(
          response,
          type: Alarm,
          filter_attribute: :site_id,
          filter_value: site_id
        )
      end
    end
  end
end
