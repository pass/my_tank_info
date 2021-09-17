# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecord < Object
    def name
      [product_name, tank_number].join(" - ")
    end

    def tank_number
      tank_numbers.join(", ")
    end

    def started_at
      DateTime.parse(start_date_time)
    end

    def is_missing?
      is_missing
    end
  end
end
