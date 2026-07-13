# frozen_string_literal: true

module MyTankInfo
  class SensorStatusResult < Object
    # MyTI's `status_is_good` flag is unreliable: it comes back false on
    # closed records (and some ongoing ones) whose status text reads
    # "Sensor Normal" or "Input Normal". The human-readable status text is
    # authoritative, so derive passing from it rather than the flag.
    def passing?
      status.to_s.match?(/normal/i)
    end
  end
end
