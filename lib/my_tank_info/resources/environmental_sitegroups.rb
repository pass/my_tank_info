# frozen_string_literal: true

module MyTankInfo
  class EnvironmentalSitegroupsResource < Resource
    def list
      Collection.from_response(get_request("api/environmental/sitegroups"), type: EnvironmentalSitegroup)
    end
  end
end
