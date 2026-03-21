# DateValues::Rails

Rails integration for [date_values](https://github.com/ursm/date_values) — ActiveModel type casting, validation, and I18n support for `YearMonth`, `MonthDay`, and `TimeOfDay`.

## Installation

```bash
bundle add date_values-rails
```

This will also install `date_values` as a dependency.

## Usage

```ruby
class Shop < ApplicationRecord
  attribute :billing_month, :year_month   # string column "2026-03"
  attribute :anniversary,   :month_day    # string column "--03-19"
  attribute :opens_at,      :time_of_day  # string or time column
end
```

### Type Casting

Attributes accept strings, Hash params, and native objects:

```ruby
# String (lenient — "3/19", "03-19", "--03-19" all work)
shop = Shop.new(anniversary: '3/19')

# Hash (from select-based form inputs)
# params[:shop][:anniversary] => {"month" => "3", "day" => "19"}
shop = Shop.new(anniversary: params[:shop][:anniversary])

# Native object
shop = Shop.new(anniversary: MonthDay.new(3, 19))

shop.anniversary  # => #<DateValues::MonthDay --03-19>
```

### Queries

Values are automatically serialized in queries:

```ruby
Shop.where(billing_month: YearMonth.new(2026, 3))
# SELECT * FROM shops WHERE billing_month = '2026-03'
```

### Validation

All classes are `Comparable` and value-equal, so standard Rails validators work as-is:

```ruby
class Contract < ApplicationRecord
  attribute :start_month, :year_month
  attribute :opens_at,    :time_of_day

  validates :start_month, comparison: {greater_than: -> { YearMonth.from(Date.current) }}
  validates :opens_at,    comparison: {
    greater_than_or_equal_to: TimeOfDay.new(9, 0),
    less_than_or_equal_to:    TimeOfDay.new(17, 0)
  }
end
```

Invalid input (e.g. `"25:00"`) is cast to `nil` rather than raising, following the same convention as Rails' built-in types. The `date_value` validator detects this and gives a meaningful error message:

```ruby
class Shop < ApplicationRecord
  attribute :opens_at, :time_of_day

  validates :opens_at, presence: true, date_value: true
end

Shop.new(opens_at: '25:00').errors[:opens_at]  # => ["is invalid"]
Shop.new(opens_at: '').errors[:opens_at]       # => ["can't be blank"]
```

### I18n / `l` Helper

All classes implement `#strftime`, and the Rails integration extends `I18n.l` to support them. Define formats in your locale files:

```yaml
# config/locales/en.yml
en:
  year_month:
    formats:
      default: '%B %Y'
  month_day:
    formats:
      default: '%B %-d'
  time_of_day:
    formats:
      default: '%-I:%M %p'
      long: '%-I:%M:%S %p'
```

```yaml
# config/locales/ja.yml
ja:
  year_month:
    formats:
      default: '%Y年%-m月'
  month_day:
    formats:
      default: '%-m月%-d日'
  time_of_day:
    formats:
      default: '%-H時%-M分'
      long: '%-H時%-M分%-S秒'
```

```ruby
I18n.l YearMonth.new(2026, 3), locale: :en   # => "March 2026"
I18n.l YearMonth.new(2026, 3), locale: :ja   # => "2026年3月"
I18n.l TimeOfDay.new(14, 30), format: :long  # => "2:30:00 PM"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
