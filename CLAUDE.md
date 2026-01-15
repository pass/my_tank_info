# MyTankInfo Ruby Gem

API client for mytankinfo.com - fuel tank inventory, environmental monitoring, alarms, deliveries.

## Dev

```bash
bundle install
rake test  # or: bundle exec rake
```

Ruby 3.0+, tests via Minitest.

## Structure

- `lib/my_tank_info/client.rb` - entry point, init w/ `api_key`
- `lib/my_tank_info/resource.rb` - base HTTP layer
- `lib/my_tank_info/object.rb` - base domain model (auto camelCase→snake_case)
- `lib/my_tank_info/resources/` - API endpoint wrappers (CRUD)
- `lib/my_tank_info/objects/` - domain models (~34)
- `lib/my_tank_info/errors/` - typed exceptions
- `test/fixtures/` - JSON response fixtures by endpoint

## Conventions

- Frozen string literals everywhere
- Resource methods: `list`, `retrieve(id)`, `update(id, **attrs)`, `create(**attrs)`, `delete(id)`
- Date format: `MYTI_DATE_TIME_FORMAT` = `"%Y-%m-%dT%H:%M:%S%:z"`
- Tests stub Faraday; one test file per resource

## Adding New Endpoints

1. Create object in `lib/my_tank_info/objects/`
2. Create resource in `lib/my_tank_info/resources/`
3. Add autoload + accessor method in `client.rb`
4. Add fixtures in `test/fixtures/`
5. Add test in `test/resources/`
