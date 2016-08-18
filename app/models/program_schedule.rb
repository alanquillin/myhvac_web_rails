class ProgramSchedule < ApplicationRecord
  belongs_to :program

  validates_presence_of :days_of_week_bin_aggr
  validates_presence_of :program_id
  validates_presence_of :time_of_day
  validate :validate_cool_or_heat_values

  def days_of_week
    build_days_of_week_part_lists unless defined? @days_of_week

    @days_of_week
  end

  def days_of_week_indexes
    build_days_of_week_part_lists unless defined? @days_of_week_indexes

    @days_of_week_indexes
  end

  def days_of_week_values
    build_days_of_week_part_lists unless defined? @days_of_week_values

    @days_of_week_values
  end

  private

  def validate_cool_or_heat_values
    logger.debug "Validating cool/heat temps exist.  Cool: #{cool_temp}, Heat: #{heat_temp}"
    if cool_temp.nil? && heat_temp.nil?
      errors.add(:cool_temp, 'must be set if no Heat temp is set')
      errors.add(:heat_temp, 'must be set if no Cool temp is set')
      return false
    end

    if cool_temp.present? && heat_temp.present?
      if cool_temp < heat_temp
        errors.add(:cool_temp, 'cannot be less than heat_temp')
        errors.add(:heat_temp, 'cannot be greater than cool_temp')
      end

      if cool_temp - heat_temp < 2
        errors.add(:cool_temp, 'must be at least 2 degrees higher than heat_temp')
        errors.add(:heat_temp, 'must be at least 2 degrees lower than cool_temp')
      end
    end

    true
  end

  def build_days_of_week_part_lists
    @days_of_week = []
    @days_of_week_indexes = []
    @days_of_week_values = []

    return if days_of_week_bin_aggr.nil?

    dow = days_of_week_bin_aggr.to_s(2).split('').reverse.map {|v| v == '1' ? true : false}
    return if dow.empty?

    Date::DAYNAMES.each_with_index do |day, i|
      if i > dow.length - 1
        break
      end

      if dow[i]
        @days_of_week << day
        @days_of_week_indexes << i
        @days_of_week_values << (1 << i)
      end
    end
  end
end
