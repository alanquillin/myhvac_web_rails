class Dashboard
  def initialize(rooms, system_settings)
    @rooms = rooms
    @system_settings = system_settings
  end

  attr_reader :rooms, :system_settings

  def mode
    @system_settings.mode
  end

  def current_program
    @system_settings.current_program
  end

  def current_temp
    cnt = 0
    total_temp = 0.0

    rooms.active.each do |room|
      if not room.current_temp.nil?
        cnt += 1
        total_temp += room.current_temp
      end
    end

    return nil unless cnt > 0

    total_temp / cnt
  end
end