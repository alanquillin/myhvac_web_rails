class Dashboard
  def initialize
    @myhvac_service_client = MyHVACService.new
    reset
  end

  def reset
    @rooms = nil
    @system_state = nil
    @system_settings = nil
  end

  def rooms
    if @rooms.nil?
      @rooms = Room.all
    end

    @rooms
  end

  def system_settings
    if @system_settings.nil?
      @system_settings = SystemSetting.first
    end

    @system_settings
  end

  def mode
    self.system_settings.mode
  end

  def current_program
    self.system_settings.current_program
  end

  def system_state
    if @system_state.nil?
      @system_state = @myhvac_service_client.system_state
    end
    @system_state
  end

  def current_temp
    cnt = 0
    total_temp = 0.0

    @rooms.active.each do |room|
      if room.current_temp.present?
        cnt += 1
        total_temp += room.current_temp
      end
    end

    return nil unless cnt > 0

    total_temp / cnt
  end
end