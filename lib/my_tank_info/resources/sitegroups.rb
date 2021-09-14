# frozen_string_literal: true

module MyTankInfo
  class SitegroupsResource < Resource
    def list(**params)
      response = get("api/environmental/sitegroups", params: params)
      Collection.from_response(response, type: Sitegroup)
    end
  end
end
