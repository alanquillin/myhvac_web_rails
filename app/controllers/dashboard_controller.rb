class DashboardController < ApplicationController
  def index
    @dashboard = Dashboard.new(Room.all, SystemSetting.first)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update_system_settings
    p = params.require(:system_setting).permit(:current_program_id, :system_mode_id, :cool_temp, :heat_temp)

    curr_system_settings = SystemSetting.find(params[:id])
    @system_setting = curr_system_settings.dup
    @system_setting.save

    curr_system_settings.active = false
    curr_system_settings.save

    if @system_setting.update(p)
      respond_to do |format|
         format.js
      end
    end

  end
end
