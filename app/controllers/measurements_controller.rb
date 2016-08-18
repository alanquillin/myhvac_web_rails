class MeasurementsController < ApplicationController
  before_action :load_sensor

  def index
    @measurements = @sensor.measurements
    @count = @measurements.count
  end

  def create
    @measurement = @sensor.measurements.new(measurement_params)

    if @measurement.save
      render :show, status: :created
    else
      render json: @measurement.errors, status: :unprocessable_entity
    end
  end

  def temperature_measurements
    all = @sensor.measurements.temperatures
    @measurements = paginate(all)
    @count = all.count
    render :index, status: :ok
  end

  def humidity_measurements
    all = @sensor.measurements.humidities
    @measurements = paginate(all)
    @count = all.count
    render :index, status: :ok
  end

  def create_temperature_measurement
    p = special_measurement_params('Temperature', :f, :c, :fahrenheit, :celsius)

    # Remove alias parameters
    f = p.delete(:f)
    fahrenheit = p.delete(:fahrenheit)
    c = p.delete(:c)
    celsius = p.delete(:celsius)

    if p.fetch(:data, nil).nil?
      f = fahrenheit if f.nil?
      c = celsius if c.nil?

      if f.nil? and c.nil?
        return render json: {:error => 'No temperature data found'}, status: :bad_request
      end

      if f.nil?
        f = convert_celsius_to_fahrenheit(c)
      end
      p[:data] = f
    end

    @measurement = @sensor.measurements.new(p)

    if @measurement.save
      render :show, status: :created
    else
      render json: @measurement.errors, status: :unprocessable_entity
    end
  end

  def create_humidity_measurement
    @measurement = @sensor.measurements.new(special_measurement_params('Humidity'))

    if @measurement.save
      render :show, status: :created
    else
      render json: @measurement.errors, status: :unprocessable_entity
    end
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
