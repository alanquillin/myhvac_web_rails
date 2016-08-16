module SchedulesHelper
  def schedules_for_day(schedules, day_i)
    schedules.select {|schedule| schedule.days_of_week_indexes.include? day_i}
  end

  def days_of_week_selector_options
    selections = Date::DAYNAMES.map.with_index { |day, i| [day, 1 << i]}
    selected =  @schedule.days_of_week_values

    options_for_select(selections, selected)
  end
end
