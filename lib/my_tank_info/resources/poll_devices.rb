# frozen_string_literal: true

module MyTankInfo
  # Admin API (FullAdmin role). Data is scoped to the caller's company.
  class PollDevicesResource < Resource
    # Bulk: comm device + polling config for every site the caller can see,
    # one row per device.
    def list
      response = get_request("api/admin/polldevices")
      Collection.from_response(response, type: PollDevice)
    end

    # Comm device + polling endpoint configuration for a single site.
    def retrieve(site_id:)
      PollDevice.new get_request("api/admin/#{site_id}/polldevice").body
    end
  end
end
