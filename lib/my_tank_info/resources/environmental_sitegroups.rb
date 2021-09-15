# frozen_string_literal: true

module MyTankInfo
  class EnvironmentalSitegroupsResource < Resource
    def list(environmental: true)
      Collection.from_response(get("api/environmental/sitegroups"), type: EnvironmentalSitegroup)
    end
  end
end
