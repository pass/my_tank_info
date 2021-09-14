# frozen_string_literal: true

module MyTankInfo
  class LineLeakResultsResource < Resource
    def list(site_id:, **params)
      response = get("api/environmental/sites/#{site_id}/lineleaks", params: params)
      Collection.from_response(response, type: LineLeakResult)
    end
  end
end
