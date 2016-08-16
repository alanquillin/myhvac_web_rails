class SchedulesController < ApplicationController
  before_action :load_program
  before_action :load_schedule, only: [:show, :edit, :update, :destroy]

  def index
    @schedules = @program.schedules
  end

  def show
  end

  def new
    @schedule = @program.schedules.new
  end

  def create
    p = schedule_params
    days_of_week = calculate_days_of_week(p)
    logger.debug "Calculated days of week value=#{days_of_week}"

    @schedule = @program.schedules.new(p)
    @schedule.days_of_week_bin_aggr = days_of_week if !days_of_week.nil? && days_of_week > 0

    if @schedule.save
      redirect_to @program, notice: 'Program successfully created!'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    p = schedule_params
    days_of_week = calculate_days_of_week(p)

    @schedule.days_of_week_bin_aggr = days_of_week

    if @schedule.update(p)
      redirect_to @program, notice: 'Program updated successfully!'
    else
      render action: :edit
    end
  end

  def destroy
    @schedule.destroy

    redirect_to @program, notice: 'Schedule removed successfully.'
  end

  private

  def load_program
    @program = Program.find(params[:program_id])
  end

  def load_schedule
    @schedule = ProgramSchedule.find(params[:id])
  end

  def schedule_params
    params.require('program_schedule').permit(:cool_temp, :heat_temp, :time_of_day, :days_of_week_names => [], :days_of_week_indexes => [], :days_of_week_values => [])
  end

  def calculate_days_of_week(params)
    dow_v = params.delete(:days_of_week_values)
    dow_i = params.delete(:days_of_week_indexes)
    dow_n = params.delete(:days_of_week_names)

    if !dow_v.nil?
      return dow_v.map {|v| v.to_i}.inject(0) {|sum,x| sum + x}
    end

    if !dow_i.nil?
      return dow_i.map {|v| v.to_i}.inject(0) {|sum,i| sum + (1 << i)}
    end

    if !dow_n.nil?
      days_of_week = 0
      Date::DAYNAMES.each_with_index do |day, i|
        if dow_n.include? day
          days_of_week += 1 << i
        end
      end
      return days_of_week
    end

    nil
  end
end
