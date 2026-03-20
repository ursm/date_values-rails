# frozen_string_literal: true

module DateValues
  module Rails
    class TimeOfDayType < ActiveModel::Type::Value
      def type
        :time_of_day
      end

      def cast(value)
        case value
        when TimeOfDay then value
        when Hash      then cast_hash(value)
        when Time      then TimeOfDay.new(value.hour, value.min, value.sec)
        when String    then TimeOfDay.parse(value)
        when nil       then nil
        end
      rescue ArgumentError
        nil
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        case value
        when nil       then nil
        when Time      then TimeOfDay.new(value.hour, value.min, value.sec)
        when String    then TimeOfDay.parse(value)
        end
      end

      private

      def cast_hash(hash)
        hash   = hash.transform_keys(&:to_sym)
        hour   = hash[:hour]&.to_i
        minute = hash[:minute]&.to_i
        second = hash[:second]&.to_i
        return nil unless hour && minute

        TimeOfDay.new(hour, minute, second || 0)
      end
    end
  end
end
