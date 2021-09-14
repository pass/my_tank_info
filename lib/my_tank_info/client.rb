# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module MyTankInfo
  class Client
    BASE_URL = "https://app.mytankinfo.com"
    attr_reader :api_key

    def initialize(api_key:, adapter: Faraday.default_adapter)
      @api_key = api_key
      @adapter = adapter
    end

    def sitegroups
      SitegroupsResource.new(self)
    end

    def tanks
      TanksResource.new(self)
    end

    def alarms
      AlarmsResource.new(self)
    end

    def tank_leak_results
      TankLeakResultsResource.new(self)
    end

    def line_leak_results
      TankLeakResultsResource.new(self)
    end

    def csld_results
      CsldResultsResource.new(self)
    end

    def sensor_status_results
      SensorStatusResultsResource.new(self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter @adapter
      end
    end
  end
end
