# frozen_string_literal: true

require_relative "my_tank_info/version"

module MyTankInfo
  autoload :Client, "my_tank_info/client"
  autoload :Object, "my_tank_info/object"
  autoload :Resource, "my_tank_info/resource"
  autoload :Collection, "my_tank_info/collection"
  autoload :Error, "my_tank_info/error"

  autoload :EnvironmentalSitegroup, "my_tank_info/objects/environmental_sitegroup"
  autoload :InventorySitegroup, "my_tank_info/objects/inventory_sitegroup"
  autoload :Site, "my_tank_info/objects/site"
  autoload :Tank, "my_tank_info/objects/tank"
  autoload :Alarm, "my_tank_info/objects/alarm"
  autoload :TankLeakResult, "my_tank_info/objects/tank_leak_result"
  autoload :LineLeakResult, "my_tank_info/objects/line_leak_result"
  autoload :CsldResult, "my_tank_info/objects/csld_result"
  autoload :SensorStatusResult, "my_tank_info/objects/sensor_status_result"

  autoload :EnvironmentalSitegroupsResource, "my_tank_info/resources/environmental_sitegroups"
  autoload :InventorySitegroupsResource, "my_tank_info/resources/inventory_sitegroups"
  autoload :TanksResource, "my_tank_info/resources/tanks"
  autoload :ActiveAlarmsResource, "my_tank_info/resources/active_alarms"
  autoload :AlarmHistoryResource, "my_tank_info/resources/alarm_history"
  autoload :TankLeakResultsResource, "my_tank_info/resources/tank_leak_results"
  autoload :LineLeakResultsResource, "my_tank_info/resources/line_leak_results"
  autoload :CsldResultsResource, "my_tank_info/resources/csld_results"
  autoload :SensorStatusResultsResource, "my_tank_info/resources/sensor_status_results"
end
