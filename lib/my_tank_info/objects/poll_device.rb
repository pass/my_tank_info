# frozen_string_literal: true

require "time"

module MyTankInfo
  # Comm device + polling endpoint configuration for a site, from the admin
  # "polldevice" endpoints. The bulk endpoint returns one row per device, so a
  # site may appear more than once.
  #
  # Named PollDevice (not Device) so it can't collide with a host app's own
  # MyTankInfo::Device constant — Zeitwerk silently wins that race and the
  # gem object never loads.
  #
  # `system_id` is the same identifier MyTankInfo's Network Status Monitor
  # uses as its site ID, and `ip`/`port` are the endpoint it probes.
  class PollDevice < Object
    # link_status is uppercase ("UP"/"DOWN") on the live API.
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
