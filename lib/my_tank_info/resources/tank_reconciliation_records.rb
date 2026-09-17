# frozen_string_literal: true

require "time"

module MyTankInfo
  class TankReconciliationRecordsResource < Resource
    # The list endpoint matches a record when EITHER end of its period falls
    # inside report_start_date..report_end_date. The record that ended the
    # moment the requested period began (the last day of the previous period)
    # comes back too, so a 10-day request returns 11 days and the extra day
    # feeds the totals. Keep only the records that start inside the requested
    # range, which is what the legacy host returned.
    def list(site_id:, reconciliation_period:, **params)
      response = get_request("api/recon/sites/#{site_id}", params: params)
      records = response.body.map { |attrs| TankReconciliationRecord.new(attrs) }

      TankReconciliationRecordCollection.new(
        data: records_starting_within(records, params[:report_start_date], params[:report_end_date]),
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

    private

    def records_starting_within(records, report_start_date, report_end_date)
      starts_at = Time.parse(report_start_date.to_s) if report_start_date
      ends_at = Time.parse(report_end_date.to_s) if report_end_date

      records.select do |record|
        (starts_at.nil? || record.started_at >= starts_at) &&
          (ends_at.nil? || record.started_at <= ends_at)
      end
    end
  end
end
