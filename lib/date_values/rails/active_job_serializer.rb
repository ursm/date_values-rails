# frozen_string_literal: true

module DateValues
  module Rails
    class YearMonthSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(value)
        super('value' => value.to_s)
      end

      def deserialize(hash)
        DateValues::YearMonth.parse(hash['value'])
      end

      def klass = DateValues::YearMonth
    end

    class MonthDaySerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(value)
        super('value' => value.to_s)
      end

      def deserialize(hash)
        DateValues::MonthDay.parse(hash['value'])
      end

      def klass = DateValues::MonthDay
    end

    class TimeOfDaySerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(value)
        super('value' => value.to_s)
      end

      def deserialize(hash)
        DateValues::TimeOfDay.parse(hash['value'])
      end

      def klass = DateValues::TimeOfDay
    end
  end
end
