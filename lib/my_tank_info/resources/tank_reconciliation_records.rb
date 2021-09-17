# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecordsResource < Resource
    def list(site_id:, **params)
      response = get_request("api/recon/sites/#{site_id}", params: params)
      TankReconciliationRecordCollection.from_response(response)
    end

    def retrieve(site_id:, started_at:)
      date =
        if started_at.instance_of?(DateTime) ||
            started_at.instance_of?(Date) ||
            started_at.instance_of?(Time)
          started_at.strftime(MYTI_DATE_TIME_FORMAT)
        else
          started_at
        end

      response = get_request("api/recon/sites/#{site_id}/#{date}")
      TankReconciliationRecordCollection.from_response(response)
    end

    def update(site_id:, started_at:, **attributes)
      put("api/recon/sites/#{site_id}/#{date}", body: attributes)
    end
  end
end
