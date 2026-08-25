# frozen_string_literal: true

require "time"

module MyTankInfo
  class TankSalesRecord < Object

    def starts_at
      parse_date(begin_date_time)
    end

    def ends_at
      parse_date(end_date_time)
    end

    def is_blend?
      is_blend
    end

    def sent?
      sent
    end

    private

    # The legacy host returned MS-JSON dates ("/Date(1620792000000)/"); the
    # current host returns ISO 8601 strings ("2026-08-25T02:14:30"). Extracting
    # digits from an ISO string grabs the year and yields 1970-01-01, so only
    # apply the millisecond parse to actual MS-JSON values.
    def parse_date(json_date)
      return nil if json_date.nil? || json_date.to_s.empty?

      string = json_date.to_s
      if string.include?("Date(")
        ms_timestamp = string[/\d+/].to_i
        Time.at(ms_timestamp / 1000.0).utc
      else
        Time.parse(string)
      end
    end
  end
end
