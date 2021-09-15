# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module MyTankInfo
  class Client
    BASE_URL = "https://app.mytankinfo.com"
    attr_reader :api_key

    def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @adapter = adapter
      @stubs = stubs
    end

    def environmental_sitegroups
      EnvironmentalSitegroupsResource.new(self)
    end

    def active_alarms
      ActiveAlarmsResource.new(self)
    end

    def alarm_history
      AlarmHistoryResource.new(self)
    end

    def tank_leak_results
      TankLeakResultsResource.new(self)
    end

    def line_leak_results
      LineLeakResultsResource.new(self)
    end

    def csld_results
      CsldResultsResource.new(self)
    end

    def sensor_status_results
      SensorStatusResultsResource.new(self)
    end

    def inventory_sitegroups
      InventorySitegroupsResource.new(self)
    end

    def tanks
      TanksResource.new(self)
    end

    def sitegroup_inventory_dashboards
      SitegroupInventoryDashboardsResource.new(self)
    end

    def tank_daily_usage
      TankDailyUsageResource.new(self)
    end

    def tank_deliveries
      TankDeliveriesResource.new(self)
    end

    def tank_inventory
      TankInventoryResource.new(self)
    end

    def tank_runout
      TankRunoutResource.new(self)
    end

    def tank_reconciliation_records
      TankReconciliationRecordsResource.new(self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter @adapter, @stubs
      end
    end
  end
end
