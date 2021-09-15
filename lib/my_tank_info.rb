# frozen_string_literal: true

require_relative "my_tank_info/version"

module MyTankInfo
  MYTI_DATE_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

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

  autoload :SitegroupInventoryDashboard, "my_tank_info/objects/sitegroup_inventory_dashboard"
  autoload :TankDailyUsageRecord, "my_tank_info/objects/tank_daily_usage_record"
  autoload :TankDeliveryRecord, "my_tank_info/objects/tank_delivery_record"
  autoload :TankInventoryRecord, "my_tank_info/objects/tank_inventory_record"
  autoload :TankRunoutRecord, "my_tank_info/objects/tank_runout_record"

  autoload :TankReconciliationRecord, "my_tank_info/objects/tank_reconciliation_record"

  autoload :NotificationContact, "my_tank_info/objects/notification_contact"
  autoload :NotificationSite, "my_tank_info/objects/notification_site"

  autoload :ActiveAlarmsResource, "my_tank_info/resources/active_alarms"
  autoload :AlarmHistoryResource, "my_tank_info/resources/alarm_history"

  autoload :EnvironmentalSitegroupsResource, "my_tank_info/resources/environmental_sitegroups"
  autoload :TankLeakResultsResource, "my_tank_info/resources/tank_leak_results"
  autoload :LineLeakResultsResource, "my_tank_info/resources/line_leak_results"
  autoload :CsldResultsResource, "my_tank_info/resources/csld_results"
  autoload :SensorStatusResultsResource, "my_tank_info/resources/sensor_status_results"

  autoload :TankReconciliationRecordsResource, "my_tank_info/resources/tank_reconciliation_records"

  autoload :InventorySitegroupsResource, "my_tank_info/resources/inventory_sitegroups"
  autoload :SitegroupInventoryDashboardsResource, "my_tank_info/resources/sitegroup_inventory_dashboards"
  autoload :TanksResource, "my_tank_info/resources/tanks"
  autoload :TankDailyUsageResource, "my_tank_info/resources/tank_daily_usage"
  autoload :TankDeliveriesResource, "my_tank_info/resources/tank_deliveries"
  autoload :TankInventoryResource, "my_tank_info/resources/tank_inventory"
  autoload :TankRunoutResource, "my_tank_info/resources/tank_runout"

  autoload :NotificationContactsResource, "my_tank_info/resources/notification_contacts"
end
