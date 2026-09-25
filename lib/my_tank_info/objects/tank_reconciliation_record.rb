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

    # The calendar day the record mostly covers: the day its midpoint falls on,
    # in the record's own offset. A site that closes out at 11:51 PM reports
    # 10 Sep 23:51 to 11 Sep 23:51, which is the 11th, not the 10th. A site
    # that closes out just after midnight reports the day it starts on.
    def date
      return started_at.to_date unless ended_at

      (started_at + ((ended_at - started_at) / 2)).to_date
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
