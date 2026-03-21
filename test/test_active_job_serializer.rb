# frozen_string_literal: true

require 'test_helper'
require 'active_job'

ActiveJob::Base.logger = Logger.new(nil)

class TestActiveJobSerializer < Minitest::Test
  def test_year_month_round_trip
    ym = YearMonth.new(2026, 3)
    serialized = ActiveJob::Serializers.serialize(ym)
    assert_equal ym, ActiveJob::Serializers.deserialize(serialized)
  end

  def test_month_day_round_trip
    md = MonthDay.new(3, 19)
    serialized = ActiveJob::Serializers.serialize(md)
    assert_equal md, ActiveJob::Serializers.deserialize(serialized)
  end

  def test_time_of_day_round_trip
    tod = TimeOfDay.new(14, 30, 45)
    serialized = ActiveJob::Serializers.serialize(tod)
    assert_equal tod, ActiveJob::Serializers.deserialize(serialized)
  end

  def test_time_of_day_without_second_round_trip
    tod = TimeOfDay.new(14, 30)
    serialized = ActiveJob::Serializers.serialize(tod)
    assert_equal tod, ActiveJob::Serializers.deserialize(serialized)
  end
end
