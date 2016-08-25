module DashboardHelper
  def current_temp
    c_temp = @dashboard.current_temp
    return 0 if c_temp.nil?

    c_temp.to_f.round(2)
  end

  def current_program(system_settings)
    return 'Unknown' if system_settings.nil? || system_settings.current_program.nil?

    system_settings.current_program.name
  end

  def system_mode(system_settings)
    return 'Unknown' if system_settings.nil? || system_settings.mode.nil?

    system_settings.mode.name
  end

  def cool_temp(system_settings)
    return 'Unknown' if system_settings.mode == 'Off'
    return system_settings.cool_temp if system_settings.mode == 'Manual'

    return 'Unknown' if system_settings.current_program.nil?

    program = system_settings.current_program
    return 'Unknown' if program.schedules.empty?

    72.0
  end

  def heat_temp(system_settings)
    return 'Unknown' if system_settings.mode == 'Off'
    return system_settings.heat_temp if system_settings.mode == 'Manual'

    return 'Unknown' if system_settings.current_program.nil?

    program = system_settings.current_program
    return 'Unknown' if program.schedules.empty?

    68.0
  end
end
