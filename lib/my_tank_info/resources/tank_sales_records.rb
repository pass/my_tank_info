# frozen_string_literal: true

module MyTankInfo
  class TankSalesRecordsResource < Resource
    def list(site_id:, **params)
      response = get_request("api/recon/sites/#{site_id}/sales", params: params)
      Collection.from_response(response, type: TankSalesRecord)
    end
  end
end
