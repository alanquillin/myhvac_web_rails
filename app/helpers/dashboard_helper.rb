module DashboardHelper
  def current_temp
    c_temp = @dashboard.current_temp
    return 0 if c_temp.nil?

    c_temp.to_f.round(2)
  end

  def current_program(dashboard)
    mode = dashboard.current_system_mode
    return 'Unknown' if mode['program'].nil? || mode['program']['name'].nil?

    mode['program']['name']
  end

  def has_program(dashboard)
    mode = dashboard.current_system_mode

    mode['program'].present?
  end

  def system_mode(dashboard)
    mode = dashboard.current_system_mode
    return 'Unknown' if mode.nil? || mode['name'].nil?

    mode['name']
  end

  def cool_temp(dashboard)
    get_temp(dashboard, 'cool_temp')
  end

  def heat_temp(dashboard)
    get_temp(dashboard, 'heat_temp')
  end

  def get_active_schedule_time(dashboard)
    get_schedule_time(dashboard, 'active_schedule')
  end

  def get_next_schedule_time(dashboard)
    get_schedule_time(dashboard, 'next_schedule')
  end

  def get_active_schedule_days(dashboard)
    mode = dashboard.current_system_mode
    return 'Unknown' if mode['program'].nil? || mode['program']['active_schedule'].nil? || mode['program']['active_schedule']['days_of_week'].empty?
    logger.debug mode['program']['active_schedule']['days_of_week']
    mode['program']['active_schedule']['days_of_week'].map {|d| d[0..2] }.join(', ')
  end

  private

  def get_temp(dashboard, temp_key)
    mode = dashboard.current_system_mode

    return 'Unknown' if mode.nil? || mode['name'].nil? || mode['name'] == 'Off'

    return mode[temp_key] if mode['name'] == 'Manual'

    return 'Unknown' if mode['program'].nil? || mode['program']['active_schedule'].nil?

    mode['program']['active_schedule'][temp_key]
  end

  def get_schedule_time(dashboard, schedule_key)
    mode = dashboard.current_system_mode
    return 'Unknown' if mode['program'].nil? || mode['program'][schedule_key].nil?

    Time.strptime(mode['program'][schedule_key]['time_of_day'], '%H:%M:%S').strftime('%l:%M %p')
  end

  def display_time_difference(diff)
    if diff <= 60
      return "#{diff} mins"
    end

    hours = (diff / 60).floor
    min_rem = diff - (hours * 60)

    if diff <= 1440
      return "#{hours} hours and #{min_rem} mins"
    end

    days = (hours / 24).floor
    hours_rem = hours - (days * 24)

    return "#{days} days, #{hours_rem} hours and #{min_rem} mins"
  end
end
