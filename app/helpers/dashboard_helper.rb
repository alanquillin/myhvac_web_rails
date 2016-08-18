module DashboardHelper
  def current_temp
    c_temp = @dashboard.current_temp
    return 0 if c_temp.nil?

    c_temp.to_f.round(2)
  end

  def current_program(obj)
    return 'Unknown' if obj.nil? || obj.current_program.nil?

    obj.current_program.name
  end

  def system_mode(obj)
    return 'Unknown' if obj.nil? || obj.mode.nil?

    obj.mode.name
  end
end
