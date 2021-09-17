# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecord < Object
    def name
      [product_name, tank_number].join(" - ")
    end

    def tank_number
      tank_numbers.join(", ")
    end
  end
end
