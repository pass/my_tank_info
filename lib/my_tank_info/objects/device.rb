# frozen_string_literal: true

require "time"

module MyTankInfo
  # Comm device + polling endpoint configuration for a site. The bulk
  # endpoint returns one row per device, so a site may appear more than once.
  class Device < Object
    def link_up?
      link_status.to_s.casecmp("up").zero?
    end

    def link_last_checked_at
      parse_time(link_last_check)
    end

    def rms_last_connected_at
      parse_time(rms_last_connection)
    end

    private

    def parse_time(value)
      return nil if value.nil? || value.to_s.strip.empty?

      Time.parse(value.to_s)
    rescue ArgumentError
      nil
    end
  end
end
