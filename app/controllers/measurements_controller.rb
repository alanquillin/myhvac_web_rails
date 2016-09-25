class MeasurementsController < ApplicationController
  before_action :load_sensor
  before_action :load_room

  def index
    if @sensor.present?
      all = @sensor.measurements
    else
      all = @room.measurements
    end

    @measurements = all
    @count = @measurements.count
  end

  def show
    if @sensor.present?
      measurement = @sensor.measurements
    else
      measurement = @room.measurements
    end
    @measurement = measurement
  end

  def temperature_measurements
    if @sensor.present?
      all = @sensor.measurements.temperatures
    else
      all = @room.measurements.temperatures
    end

    @measurements = paginate(all)
    @count = all.count
    render :index, status: :ok
  end

  def humidity_measurements
    if @sensor.present?
      all = @sensor.measurements.humidities
    else
      all = @room.measurements.humidities
    end

    @measurements = paginate(all)
    @count = all.count
    render :index, status: :ok
  end

  private

  def measurement_params
    p = params.require(:measurement).permit(:data, :measurement_type_id, :recorded_date, measurement_type: [:name])
    measurement_type = p.delete(:measurement_type)
    if not measurement_type.nil? and p.fetch(:measurement_type_id, nil).nil?
      name = measurement_type.fetch(:name, nil)

      measurement_type = MeasurementType.find_by(:name => name)

      if measurement_type.nil?
        return render json: {:error => 'Unknown or missing measurement type'}, status: :bad_request
      end

      p[:measurement_type_id] = measurement_type.id
    end

    p
  end

  def special_measurement_params(measurement_type_name, *filters)
    p = params.require(measurement_type_name.downcase).permit(:data, :recorded_date, filters)
    p[:measurement_type_id] = MeasurementType.find_by(:name => measurement_type_name).id

    if p.fetch(:recorded_date, nil).nil?
      p[:recorded_date] = DateTime.now
    end

    p
  end

  def load_sensor
    @sensor = Sensor.find_by_any_id(params[:sensor_id]).first
  end

  def load_room
    @room = Room.find(params[:room_id])
  end

  def convert_celsius_to_fahrenheit(c)
    c * 1.8 + 32.0
  end

  def paginate(query, defaults = {})
    if defaults.fetch(:sort_column, nil).nil?
      defaults[:sort_column] = :recorded_date
    end

    super(query, defaults)
  end
end
