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

  private

  def get_temp(dashboard, temp_key)
    mode = dashboard.current_system_mode

    return 'Unknown' if mode.nil? || mode['name'].nil? || mode['name'] == 'Off'

    return mode[temp_key] if mode['name'] == 'Manual'

    return 'Unknown' if mode['program'].nil? || mode['program']['active_schedule'].nil?

    mode['program']['active_schedule'][temp_key]
  end
end
