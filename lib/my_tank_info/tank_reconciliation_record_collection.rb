# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecordCollection
    attr_reader :data, :size, :tanks, :site_id, :started_at, :ended_at

    def self.from_response(response)
      body = response.body

      @collection = new(
        data: body.map { |attrs| TankReconciliationRecord.new(attrs) }
      )
    end

    def initialize(data:)
      @data = data
      @size = @data.size

      @site_id = @data.first.site_id
      @started_at = @data.min_by(&:started_at).started_at
      @ended_at = @data.max_by(&:started_at).started_at

      @tanks =
        @data.map do |record|
          records = @data.select { _1.tank_number == record.tank_number }.sort_by(&:started_at)

          Tank.new(
            name: record.name,
            product_name: record.product_name,
            tank_number: record.tank_number,
            capacity: record.total_tanks_capacity,
            reconciliation_records: records,
            reconciliation_summary: TankReconciliationRecordSummary.new(
              records,
              capacity: record.total_tanks_capacity
            )
          )
        end
    end
  end
end
