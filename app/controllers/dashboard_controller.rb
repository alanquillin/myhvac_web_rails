class DashboardController < ApplicationController
  def index
    @dashboard = Dashboard.new(Room.all, SystemSetting.first)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
