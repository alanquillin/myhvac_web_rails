module DashboardHelper
  def current_temp
    c_temp = @dashboard.current_temp
    return 0 if c_temp.nil?

    c_temp.to_f.round(2)
  end

  def current_program
    return 'Unknown' if @dashboard.current_program.nil?

    return @dashboard.current_program.name
  end
end
