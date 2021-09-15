# frozen_string_literal: true

module MyTankInfo
  class InventorySitegroupsResource < Resource
    def list(environmental: true)
      Collection.from_response(get_request("api/sitegroups"), type: InventorySitegroup)
    end
  end
end
