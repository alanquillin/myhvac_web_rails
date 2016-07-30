class RoomSensorsController < ApplicationController
  before_action :load_room
  def index
    @sensors = @room.sensors
  end

  private

  def load_room
    @room = Room.find(params[:room_id])
  end
end
