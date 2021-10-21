# frozen_string_literal: true

module MyTankInfo
  class Alarm < Object
    def canonical_id
      if alarm_history_id.nil?
        id
      else
        alarm_history_id
      end
    end
  end
end
