class ProgramsController < ApplicationController
  before_action :set_program, only: [:show, :edit, :update, :destroy]

  def index
    @programs = Program.all
  end

  def show
  end

  def new
    @program = Program.new
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      redirect_to programs_path, notice: 'Program successfully created!'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @program.update(program_params)
      redirect_to @program, notice: 'Program updated successfully!'
    else
      render action: :edit
    end
  end

  def destroy
    name = @program.name
    @program.destroy

    redirect_to programs_path, notice: "Program \"#{name}\" removed successfully."
  end

  private

  def set_program
    @program = Program.find(params[:id])
  end

  def program_params
    params.require(:program).permit(:name)
  end
end
