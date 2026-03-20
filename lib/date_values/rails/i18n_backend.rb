# frozen_string_literal: true

module DateValues
  module Rails
    module I18nBackend
      TYPES = {
        DateValues::YearMonth  => :year_month,
        DateValues::MonthDay   => :month_day,
        DateValues::TimeOfDay  => :time_of_day
      }.freeze

      def localize(locale, object, format = :default, options = EMPTY_HASH)
        type = TYPES[object.class]
        return super unless type

        format_key = format.is_a?(Symbol) ? format : nil

        if format_key
          entry = I18n.t("#{type}.formats.#{format_key}", locale: locale, default: nil)
          raise I18n::MissingTranslationData.new(locale, "#{type}.formats.#{format_key}") unless entry

          format = entry
        end

        object.strftime(format)
      end
    end
  end
end
