## [Unreleased]

## [0.1.1] - 2026-03-20

- Auto-require via Bundler — no explicit `require 'date_values/rails'` needed in Rails apps

## [0.1.0] - 2026-03-20

- Extracted from [date_values](https://github.com/ursm/date_values) gem
- ActiveModel types: `:year_month`, `:month_day`, `:time_of_day`
- ActiveRecord type registration via `ActiveSupport.on_load`
- I18n backend extension for Rails `l` helper
- `date_value` validator for invalid input detection
- Cast accepts Hash params from forms and lenient string formats
