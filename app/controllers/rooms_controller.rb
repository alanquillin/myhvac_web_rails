class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  def index
    @rooms = Room.all
  end

  def show
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path, notice: 'Room successfully created!'
    else
      render action: new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: 'Room updated successfully!'
    else
      render action: :edit
    end
  end

  def destroy
    @room.destroy

    redirect_to rooms_path, notice: "Room \"#{@room.name}\" removed successfully."
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :weight, :active)
  end
end
