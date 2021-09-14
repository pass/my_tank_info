# frozen_string_literal: true

module MyTankInfo
  class TankLeakResultsResource < Resource
    def list(site_id:, **params)
      response = get("api/environmental/sites/#{site_id}/tankleaks", params: params)
      Collection.from_response(response, type: TankLeakResult)
    end
  end
end
