# frozen_string_literal: true

require "time"

module MyTankInfo
  class TankReconciliationRecordsResource < Resource
    # The list endpoint matches a record when EITHER end of its period falls
    # inside report_start_date..report_end_date. The record that ended the
    # moment the requested period began (the last day of the previous period)
    # comes back too, so a 10-day request returns 11 days and the extra day
    # feeds the totals. Keep only the records whose day (see
    # TankReconciliationRecord#date) falls inside the requested dates. Filtering
    # on the start time is not enough: a site that closes out before midnight
    # starts each day the evening before, so the record for the day after the
    # period also starts inside it.
    def list(site_id:, reconciliation_period:, **params)
      params = params.transform_keys(&:to_sym)
      response = get_request("api/recon/sites/#{site_id}", params: params)
      records = response.body.map { |attrs| TankReconciliationRecord.new(attrs) }

      TankReconciliationRecordCollection.new(
        data: records_dated_within(records, params[:report_start_date], params[:report_end_date]),
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

    def records_dated_within(records, report_start_date, report_end_date)
      starts_on = Time.parse(report_start_date.to_s).to_date if report_start_date
      ends_on = Time.parse(report_end_date.to_s).to_date if report_end_date

      records.select do |record|
        (starts_on.nil? || record.date >= starts_on) &&
          (ends_on.nil? || record.date <= ends_on)
      end
    end
  end
end
