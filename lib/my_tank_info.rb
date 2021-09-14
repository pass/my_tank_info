# frozen_string_literal: true

require_relative "my_tank_info/version"

module MyTankInfo
  autoload :Client, "my_tank_info/client"
  autoload :Object, "my_tank_info/object"
  autoload :Resource, "my_tank_info/resource"
  autoload :Collection, "my_tank_info/collection"
  autoload :Error, "my_tank_info/error"

  autoload :Sitegroup, "my_tank_info/objects/sitegroup"
  autoload :Site, "my_tank_info/objects/site"
  autoload :Tank, "my_tank_info/objects/tank"
  autoload :Alarm, "my_tank_info/objects/alarm"
  autoload :TankLeakResult, "my_tank_info/objects/tank_leak_result"
  autoload :LineLeakResult, "my_tank_info/objects/line_leak_result"
  autoload :CsldResult, "my_tank_info/objects/csld_result"
  autoload :SensorStatusResult, "my_tank_info/objects/sensor_status_result"

  autoload :SitegroupsResource, "my_tank_info/resources/sitegroups"
  autoload :AlarmsResource, "my_tank_info/resources/alarms"
  autoload :TanksResource, "my_tank_info/resources/tanks"
  autoload :AlarmHistoryResource, "my_tank_info/resources/alarm_history"
  autoload :TankLeakResultsResource, "my_tank_info/resources/tank_leak_results"
  autoload :LineLeakResultsResource, "my_tank_info/resources/line_leak_results"
  autoload :CsldResultsResource, "my_tank_info/resources/csld_results"
  autoload :SensorStatusResultsResource, "my_tank_info/resources/sensor_status_results"
end
