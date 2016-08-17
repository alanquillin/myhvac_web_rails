class Dashboard
  def initialize(rooms, system_settings)
    @rooms = rooms
    @system_mode = system_settings.mode
    @current_program = system_settings.current_program
  end

  attr_reader :rooms
  attr_reader :system_mode
  attr_reader :current_program

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