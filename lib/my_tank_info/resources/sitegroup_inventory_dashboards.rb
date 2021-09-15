# frozen_string_literal: true

module MyTankInfo
  class SitegroupInventoryDashboardsResource < Resource
    def list(sitegroup_id:)
      Collection.from_response(
        get_request("api/sitegroups/#{sitegroup_id}/inventory/dashboard"),
        type: SitegroupInventoryDashboard
      )
    end
  end
end
