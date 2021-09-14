# frozen_string_literal: true

module MyTankInfo
  class AlarmsResource < Resource
    def list(site_id: nil, **params)
      response = get("api/alarms", params: params)
      Collection.from_response(response, type: Alarm)

      collection = Collection.from_response(response, type: Alarm)

      if site_id.nil?
        collection
      else
        collection.select { |alarm| alarm.site_id == site_id }
      end
    end
  end
end
