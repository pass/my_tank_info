# frozen_string_literal: true

module MyTankInfo
  class TankSalesRecord < Object

    def starts_at
      parse_ms_json_date(begin_date_time)
    end

    def ends_at
      parse_ms_json_date(end_date_time)
    end

    def is_blend?
      is_blend
    end

    def sent?
      sent
    end

    private

    def parse_ms_json_date(json_date)
      ms_timestamp = json_date[/\d+/].to_i
      Time.at(ms_timestamp / 1000.0).utc
    end
  end
end
