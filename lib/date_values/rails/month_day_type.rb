# frozen_string_literal: true

module DateValues
  module Rails
    class MonthDayType < ActiveModel::Type::Value
      def type
        :month_day
      end

      def cast(value)
        case value
        when MonthDay then value
        when Hash     then cast_hash(value)
        when String   then MonthDay.parse(value)
        when nil      then nil
        end
      rescue ArgumentError
        nil
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        return nil if value.nil?

        MonthDay.parse(value)
      end

      private

      def cast_hash(hash)
        hash  = hash.transform_keys(&:to_sym)
        month = hash[:month]&.to_i
        day   = hash[:day]&.to_i
        return nil unless month && day

        MonthDay.new(month, day)
      end
    end
  end
end
