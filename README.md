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

```ruby
client = MyTankInfo::Client.new(api_key: ENV["MYTANKINFO_API_KEY"])

client.sitegroups.list
client.tanks.list

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kylekeesling/my_tank_info. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kylekeesling/my_tank_info/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MyTankInfo project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kylekeesling/my_tank_info/blob/master/CODE_OF_CONDUCT.md).
