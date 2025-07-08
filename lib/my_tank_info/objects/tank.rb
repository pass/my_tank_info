# frozen_string_literal: true

module MyTankInfo
  class Tank < Object

    def daily_usage
      @original_attributes["daily_usage"] || 0
    end

    def daily_usage_trend
      @original_attributes["dailyUsage"] || []
    end
  end
end
