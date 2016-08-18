module ApplicationHelper
  def print_temp(temp)
    return '' if temp.nil?

    "#{temp}° F"
  end
end
