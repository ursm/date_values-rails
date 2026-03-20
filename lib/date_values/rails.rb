# frozen_string_literal: true

require 'date_values'
require_relative 'rails/version'
require 'active_support'
require 'active_model/type'
require_relative 'rails/year_month_type'
require_relative 'rails/month_day_type'
require_relative 'rails/time_of_day_type'
require_relative 'rails/i18n_backend'
require_relative 'rails/date_value_validator'

ActiveModel::Type.register(:year_month, DateValues::Rails::YearMonthType)
ActiveModel::Type.register(:month_day, DateValues::Rails::MonthDayType)
ActiveModel::Type.register(:time_of_day, DateValues::Rails::TimeOfDayType)

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:year_month, DateValues::Rails::YearMonthType)
  ActiveRecord::Type.register(:month_day, DateValues::Rails::MonthDayType)
  ActiveRecord::Type.register(:time_of_day, DateValues::Rails::TimeOfDayType)
end

I18n::Backend::Base.prepend(DateValues::Rails::I18nBackend)
