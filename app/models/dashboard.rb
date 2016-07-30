class Dashboard
  def initialize(rooms)
    @rooms = rooms
  end

  attr_reader :rooms

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