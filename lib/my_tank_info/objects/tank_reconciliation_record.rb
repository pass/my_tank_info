# frozen_string_literal: true

require "time"

module MyTankInfo
  class TankReconciliationRecord < Object
    def name
      [tank_number, product_name].join(" - ")
    end

    def tank_number
      tank_numbers.join(", ")
    end

    def started_at
      Time.parse(start_date_time)
    end

    def ended_at
      Time.parse(end_date_time) if end_date_time
    end

    # The day the record reconciles, as MyTankInfo labels it: the day it
    # starts, in the record's own offset. When a site's closeout moves from
    # just after midnight to the evening before, MyTankInfo merges the two
    # records that would otherwise start on the same day, so every day still
    # gets one record.
    def date
      started_at.to_date
    end

    def is_missing?
      is_missing
    end

    def book_inventory
      (start_volume + deliveries_volume) - sales_volume
    end

    # Used for Weekly reconciliation
    def removed_from_ust
      (start_volume + deliveries_volume) - end_volume
    end
  end
end
