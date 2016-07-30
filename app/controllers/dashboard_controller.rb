class DashboardController < ApplicationController
  def index
    @dashboard = Dashboard.new(Room.all)
  end
end
