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

    # Changes where MyTankInfo polls a site's device. Attributes are
    # system_id, target_type ("IP" or "Name"), host, and port; system_id must
    # match a device at the site. MyTankInfo's VPN server picks up the change
    # within 5 minutes.
    def update(site_id:, **attributes)
      request = put_request("api/admin/#{site_id}/polldevice", body: attributes)
      PollDevice.new request.body
    end
  end
end
