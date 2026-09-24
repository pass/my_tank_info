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

    # Changes where MyTankInfo polls a site's device. Updates an existing
    # entry only: system_id must match a device at the site. target_type is
    # "IP" or "Name". MyTankInfo's VPN server picks up the change within 5
    # minutes. Returns the saved status, system_id, target_type, host, and port.
    def update(site_id:, system_id:, target_type:, host:, port:)
      body = {system_id: system_id, target_type: target_type, host: host, port: port}
      PollDevice.new put_request("api/admin/#{site_id}/polldevice", body: body).body
    end
  end
end
