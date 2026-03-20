# frozen_string_literal: true

require 'test_helper'
require 'active_record'
require 'date_values/rails'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table :shops do |t|
    t.string :billing_month
    t.string :anniversary
    t.string :opens_at
  end
end

class Shop < ActiveRecord::Base
  attribute :billing_month, :year_month
  attribute :anniversary,   :month_day
  attribute :opens_at,      :time_of_day

  validates :opens_at, date_value: true
end

class TestActiveRecord < Minitest::Test
  def setup
    Shop.create!(billing_month: YearMonth.new(2026, 1), anniversary: MonthDay.new(3, 19), opens_at: TimeOfDay.new(9, 0))
    Shop.create!(billing_month: YearMonth.new(2026, 2), anniversary: MonthDay.new(12, 25), opens_at: TimeOfDay.new(10, 0))
  end

  def teardown
    Shop.delete_all
  end

  def test_where_year_month
    assert_equal 1, Shop.where(billing_month: YearMonth.new(2026, 1)).count
  end

  def test_where_month_day
    assert_equal 1, Shop.where(anniversary: MonthDay.new(3, 19)).count
  end

  def test_where_time_of_day
    assert_equal 1, Shop.where(opens_at: TimeOfDay.new(9, 0)).count
  end

  def test_where_with_array
    assert_equal 2, Shop.where(billing_month: [YearMonth.new(2026, 1), YearMonth.new(2026, 2)]).count
  end

  def test_read_back
    shop = Shop.find_by(billing_month: YearMonth.new(2026, 1))
    assert_instance_of DateValues::YearMonth, shop.billing_month
    assert_instance_of DateValues::MonthDay, shop.anniversary
    assert_instance_of DateValues::TimeOfDay, shop.opens_at
  end

  def test_cast_invalid_returns_nil
    shop = Shop.new(opens_at: '25:00')
    assert_nil shop.opens_at
  end

  def test_validator_invalid_input
    shop = Shop.new(opens_at: '25:00')
    refute shop.valid?
    assert_includes shop.errors[:opens_at], 'is invalid'
  end

  def test_validator_valid_input
    shop = Shop.new(opens_at: '09:00')
    assert shop.valid?
  end

  def test_validator_blank_input
    shop = Shop.new(opens_at: '')
    assert shop.valid?
  end

  def test_validator_nil_input
    shop = Shop.new(opens_at: nil)
    assert shop.valid?
  end
end
