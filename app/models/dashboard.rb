class Dashboard
  def initialize
    @myhvac_service_client = MyhvacService.new
    reset
  end

  def reset
    @rooms = nil
    @system_status = nil
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
    system_status['state']
  end

  def current_temp
    system_status['current_temp']
  end

  private

  def system_status
    if @system_status.nil?
      @system_status = @myhvac_service_client.system_status
    end
    @system_status
  end
end