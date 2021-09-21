# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecordsResource < Resource
    def list(site_id:, reconciliation_period:, **params)
      response = get_request("api/recon/sites/#{site_id}", params: params)
      TankReconciliationRecordCollection.from_response(
        response,
        reconciliation_period: reconciliation_period
      )
    end

    def retrieve(site_id:, reconciliation_period:, started_at:)
      date =
        if started_at.instance_of?(DateTime) ||
            started_at.instance_of?(Date) ||
            started_at.instance_of?(Time)
          started_at.strftime(MYTI_DATE_TIME_FORMAT)
        else
          started_at
        end

      response = get_request("api/recon/sites/#{site_id}/#{date}")
      TankReconciliationRecordCollection.from_response(
        response,
        reconciliation_period: reconciliation_period
      )
    end

    def update(site_id:, date:, reconciliation_period:, attributes:)
      response = put_request("api/recon/sites/#{site_id}/#{date}", body: attributes)

      TankReconciliationRecordCollection.from_response(
        response,
        reconciliation_period: reconciliation_period
      )
    end
  end
end
