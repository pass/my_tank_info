# frozen_string_literal: true

module MyTankInfo
  class CsldResultsResource < Resource
    def list(site_id:, **params)
      response = get_request("api/environmental/sites/#{site_id}/csldstatuses", params: params)
      Collection.from_response(response, type: CsldResult)
    end
  end
end
