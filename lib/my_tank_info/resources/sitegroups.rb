# frozen_string_literal: true

module MyTankInfo
  class SitegroupsResource < Resource
    def list(environmental: true)
      response =
        if environmental
          get("api/environmental/sitegroups")
        else
          get("api/sitegroups")
        end
      Collection.from_response(response, type: Sitegroup)
    end
  end
end
