# frozen_string_literal: true

require 'test_helper'
require 'date_values/rails'

class TestYearMonthType < Minitest::Test
  def setup
    @type = DateValues::Rails::YearMonthType.new
  end

  def test_type
    assert_equal :year_month, @type.type
  end

  def test_cast_from_string
    assert_equal YearMonth.new(2026, 3), @type.cast('2026-03')
  end

  def test_cast_from_hash
    assert_equal YearMonth.new(2026, 3), @type.cast({year: 2026, month: 3})
    assert_equal YearMonth.new(2026, 3), @type.cast({'year' => '2026', 'month' => '3'})
  end

  def test_cast_from_year_month
    ym = YearMonth.new(2026, 3)
    assert_same ym, @type.cast(ym)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '2026-03', @type.serialize(YearMonth.new(2026, 3))
  end

  def test_serialize_nil
    assert_nil @type.serialize(nil)
  end

  def test_deserialize
    assert_equal YearMonth.new(2026, 3), @type.deserialize('2026-03')
  end

  def test_deserialize_nil
    assert_nil @type.deserialize(nil)
  end
end

class TestMonthDayType < Minitest::Test
  def setup
    @type = DateValues::Rails::MonthDayType.new
  end

  def test_type
    assert_equal :month_day, @type.type
  end

  def test_cast_from_string
    assert_equal MonthDay.new(3, 19), @type.cast('--03-19')
  end

  def test_cast_from_hash
    assert_equal MonthDay.new(3, 19), @type.cast({month: 3, day: 19})
    assert_equal MonthDay.new(3, 19), @type.cast({'month' => '3', 'day' => '19'})
  end

  def test_cast_from_month_day
    md = MonthDay.new(3, 19)
    assert_same md, @type.cast(md)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '--03-19', @type.serialize(MonthDay.new(3, 19))
  end

  def test_deserialize
    assert_equal MonthDay.new(3, 19), @type.deserialize('--03-19')
  end
end

class TestTimeOfDayType < Minitest::Test
  def setup
    @type = DateValues::Rails::TimeOfDayType.new
  end

  def test_type
    assert_equal :time_of_day, @type.type
  end

  def test_cast_from_string
    assert_equal TimeOfDay.new(14, 30), @type.cast('14:30')
  end

  def test_cast_from_string_with_second
    assert_equal TimeOfDay.new(14, 30, 45), @type.cast('14:30:45')
  end

  def test_cast_from_hash
    assert_equal TimeOfDay.new(14, 30), @type.cast({hour: 14, minute: 30})
    assert_equal TimeOfDay.new(14, 30, 45), @type.cast({'hour' => '14', 'minute' => '30', 'second' => '45'})
  end

  def test_cast_from_time
    assert_equal TimeOfDay.new(14, 30, 45), @type.cast(Time.new(2000, 1, 1, 14, 30, 45))
  end

  def test_cast_from_time_of_day
    tod = TimeOfDay.new(14, 30)
    assert_same tod, @type.cast(tod)
  end

  def test_cast_nil
    assert_nil @type.cast(nil)
  end

  def test_serialize
    assert_equal '14:30', @type.serialize(TimeOfDay.new(14, 30))
  end

  def test_serialize_with_second
    assert_equal '14:30:45', @type.serialize(TimeOfDay.new(14, 30, 45))
  end

  def test_deserialize
    assert_equal TimeOfDay.new(14, 30), @type.deserialize('14:30')
  end

  def test_deserialize_from_time
    assert_equal TimeOfDay.new(14, 30, 45), @type.deserialize(Time.new(2000, 1, 1, 14, 30, 45))
  end
end

class TestI18nBackend < Minitest::Test
  def setup
    I18n.available_locales = [:en, :ja]
    I18n.backend.store_translations(:ja, {
      year_month:  {formats: {default: '%Y年%-m月', short: '%Y/%m'}},
      month_day:   {formats: {default: '%-m月%-d日'}},
      time_of_day: {formats: {default: '%-H時%-M分'}}
    })
  end

  def teardown
    I18n.backend.reload!
    I18n.available_locales = nil
  end

  def test_localize_year_month
    assert_equal '2026年3月', I18n.l(YearMonth.new(2026, 3), locale: :ja)
  end

  def test_localize_year_month_with_format
    assert_equal '2026/03', I18n.l(YearMonth.new(2026, 3), locale: :ja, format: :short)
  end

  def test_localize_month_day
    assert_equal '3月19日', I18n.l(MonthDay.new(3, 19), locale: :ja)
  end

  def test_localize_time_of_day
    assert_equal '14時30分', I18n.l(TimeOfDay.new(14, 30), locale: :ja)
  end

  def test_localize_with_string_format
    assert_equal '2026-03', I18n.l(YearMonth.new(2026, 3), locale: :ja, format: '%Y-%m')
  end

  def test_localize_missing_format
    assert_raises(I18n::MissingTranslationData) {
      I18n.l(YearMonth.new(2026, 3), locale: :ja, format: :unknown)
    }
  end
end
