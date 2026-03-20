# frozen_string_literal: true

module DateValues
  module Rails
    class YearMonthType < ActiveModel::Type::Value
      def type
        :year_month
      end

      def cast(value)
        case value
        when YearMonth then value
        when Hash      then cast_hash(value)
        when String    then YearMonth.parse(value)
        when nil       then nil
        end
      rescue ArgumentError
        nil
      end

      def serialize(value)
        value&.to_s
      end

      def deserialize(value)
        return nil if value.nil?

        YearMonth.parse(value)
      end

      private

      def cast_hash(hash)
        hash = hash.transform_keys(&:to_sym)
        year  = hash[:year]&.to_i
        month = hash[:month]&.to_i
        return nil unless year && month

        YearMonth.new(year, month)
      end
    end
  end
end
