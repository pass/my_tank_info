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

    def retrieve(site_id:, date:, reconciliation_period:)
      date =
        if date.instance_of?(DateTime) ||
            date.instance_of?(Date) ||
            date.instance_of?(Time)
          date.strftime(MYTI_DATE_TIME_FORMAT)
        else
          date
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
