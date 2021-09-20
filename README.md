# MyTankInfo

[![Ruby](https://github.com/kylekeesling/my_tank_info/actions/workflows/main.yml/badge.svg)](https://github.com/kylekeesling/my_tank_info/actions/workflows/main.yml)

A simple Ruby gem for interacting with the [MyTankInfo](http://mytankinfo.com) API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'my_tank_info'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install my_tank_info

## Usage

### Creating a Client

```ruby
client = MyTankInfo::Client.new(api_key: ENV["MYTANKINFO_API_KEY"])
```

### API Tokens
You must obtain an API token in order to use this gem. Tokens appear to last for 1 year before the expire.

Once the token is generated it should be stored for use on all subsequent API requests.

Practically speaking you'll need to store the username/password for then account you'd like to access
so that you can periodically generate a new API token prior to expiration.

Alternatively you can have your code catch _403 Forbidden_ errors and use that as a sign that a new API token is needed.

This is also the only call you can perform without providing an :api_key to the client

```ruby
client.generate_api_token(username:, password:)
```
### Environmental API
```ruby
# Return a list of all sitegroups for the account
client.environmental_sitegroups

# Active Alarms records be retrived either as a full list, or filtered by :site_id
# Will return empty if there are no active alarms
client.active_alarms.list
client.active_alarms.list(site_id: 123)
```

In addition to the defined parameters below you may also pass ``:report_start_date`` and ``:report_end_date`` as optional parameters to retrive records for a given timeframe

```ruby
# Alarm History records be retrived either as a full list, or filtered by :site_id
client.alarm_history.list
client.alarm_history.list(site_id: 123)

# View Tank Leak Test Results for a site
# Will return empty if the site does not have line tank leak detection configured
client.tank_leak_results.list(site_id: 123)

# View Line Leak Test Results for a site
# Will return empty if the site does not have line leak detection configured
client.line_leak_results.list(site_id: 123)

# View Sensor Status Results for a site
# Will return empty if the site does not have Continuous iI-tank Leak Detection (CITLD), which is
# often referred to as CSLD or (Continuous Statistical Leak Detection)
client.csld_results.list(site_id: 123)

# View Sensor Status Results for a site
# Will return empty if the site does not have any sensors
client.sensor_status_results.list(site_id: 123)
```

### Reconciliation API
You may also pass ``:report_start_date`` and ``:report_end_date`` as optional parameters to retrive records for a given timeframe

```ruby
# reconciliation_period must be one of the following - :weekly, :ten_day, :monthly
client.tank_reconciliation_records.list(site_id: 123, reconciliation_period: :monthly)
```

This call returns a special collection object called `TankReconciliationRecordCollection` that gives you a number
of convienience methods for accessing the data in a easily usable way:

```ruby
collection = client.tank_reconciliation_records.list(site_id: 123, reconciliation_period: :monthly)

collection.started_at
collection.ended_at

# returns a collection of TankReconciliationRecords
collection.data

# this returns a collection of Tank objects
tanks = collection.tanks
tank = tanks.fist

tank.name # 1 - Unleaded
tank.product_name # Unleaded
tank.tank_number # 1
tank.capacity # 5000

# collection of TankReconciliationRecords belonging only to this tank
tank.reconciliation_records

# returns TankReconciliationRecordSummary object which provides
# a number of calculations based upon the provided reconciliation_period
tank.reconciliation_summary

# evaluates associated reconciliation_records based upon the
# provided reconciliation_period to decide if tank has passed
tank.passed?

# evaluates associated reconciliation_records based upon the
# provided reconciliation_period to decide if tank has failed
tank.failed?
```


### Inventory API
```ruby
# Will return a list of all sitegroups for the account, along with a host of additional data relating
# to corresponding sites and their current inventory and alarm status
client.inventory_sitegroups.list

# Tanks can be retrived either as a full list, or filtered by :site_id
client.tanks.list
client.tanks.list(site_id: 123)

# Will return a list all sites belonging to a sitegroup, along with a host of additional data relating
# each site's current inventory and alarm status
client.sitegroup_inventory_dashboards.list(sitegroup_id: 1)

# Returns daily inventory usage over the previous 4 weeks for a given tank
client.tank_daily_usage.list(tank_id: 1)

# Returns deliveries made to the given tank over a time period.
# Supports :report_start_date and :report_end_date parameters
client.tank_deliveries.list(tank_id: 1)


## To update a tank delivery, the folowing params are required in the update request
params = {
  start_date_and_time: "2021-08-10T11:48:00.0000000-04:00",
  start_gross: 500,
  stop_date_and_time: "2021-08-10T12:48:00.0000000-04:00",
  stop_gross: 600,
  delivery_net: 100,
  delivery_gross: 105,
  bol_number: "123"
}

client.tank_deliveries.update(tank_id: 1, delivery_id: 1, **params)

# Returns inventory readings for the given tank over a time period.
# Supports :report_start_date and :report_end_date parameters
client.tank_inventory.list(tank_id: 1)

# Returns recent inventory records for a tank (similiar to client.tank_deliveries.list)
# with an extra record indicating the estimated runout.

# The period of time over which the records are queried varies depending on how far out in the
# future the estimated runout is. But the results will contain inventory records from at least
# the last two days and at most the last 28 days.

client.tank_runout.list(tank_id: 1)
```

### Admin API

#### Notification Contacts
```ruby
client.notification_contacts.list

# A list of all sites that the contact is setup to recieve notifications about
# Note: will be empty if contact is setup to recieve updates for all sites (default_contact_settings: 1)
client.notification_contacts.list_sites(contact_id: 1)

client.notification_contacts.retrieve(contact_id: 1)


# Updating and creating a NotificationContact record requires the following params
params = {
  first_name: "Kyle",
  last_name: "Keesling",
  email: "kyle@example.com",
  sms_phone: "555-555-5555",
  contact_method: 3, # 1 (SMS), 2 (Email), 3 (SMS & Email)
  is_active: true,
  default_contact_settings: 1 # 0 (None/No Sites), 1 (All Sites), 2 (Only Selected Sites)
}

client.notification_contacts.update(contact_id: 1, **params)

client.notification_contacts.create(**params)

client.notification_contacts.delete(contact_id: 1)
```

#### Notification Rules
```ruby
# Provides a list of all alarm/warning codes that rules can be defined for
client.notification_rules.list_codes

# List all contacts associated with a rule
client.notification_rules.list_contacts(rule_id: 1)

# List all rules that have been defined for a given code
client.notification_rules.list(code_id: 1)

# Updating a rule requires that you pass along an array of the
# contacts who the rule should apply to as well as the prefereed
# contact method. isSuppressed will silence the rule without
# actually deleting it
params = {
  contacts: [
    {
      contactId: 3110,
      contactMethod: 3 # 1 (SMS), 2 (Email), 3 (SMS & Email)
    }
  ],
  isSuppressed: false
}

client.notification_rules.update(rule_id: 1, **params)

client.notification_rules.delete(rule_id: 1)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kylekeesling/my_tank_info. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kylekeesling/my_tank_info/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MyTankInfo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kylekeesling/my_tank_info/blob/master/CODE_OF_CONDUCT.md).
