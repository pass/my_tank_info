# frozen_string_literal: true

module MyTankInfo
  class SensorStatusResult < Object
    # MyTI's `status_is_good` flag is unreliable: it comes back false on
    # closed records (and some ongoing ones) whose status text reads
    # "Sensor Normal" or "Input Normal". The human-readable status text is
    # authoritative, so derive passing from it rather than the flag.
    #
    # Guard against negated forms ("Abnormal", "Not Normal", "Non-normal"):
    # none have been observed in the wild, but a plain substring match would
    # score them as passing — a false pass on a compliance report.
    NEGATED_NORMAL = /\b(?:ab|non|not)\W*normal/i

    def passing?
      text = status.to_s
      text.match?(/normal/i) && !text.match?(NEGATED_NORMAL)
    end
  end
end
