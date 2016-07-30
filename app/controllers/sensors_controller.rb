class SensorsController < ApplicationController
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  def index
    @sensors = Sensor.all
  end

  def show
  end

  def new
    @sensor = Sensor.new
  end

  def create
    s_params = sensor_params(sensor_type: [:manufacturer, :model])
    @sensor = Sensor.new(clean_sensor_type_data_from_params(s_params))
    respond_to do |format|
      if @sensor.save
        format.html { redirect_to sensors_path, notice: 'Sensor successfully added!' }
        format.json { render :show, status: :created, location: @sensor }
      else
        format.html { render :new }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sensor.update(sensor_params)
        format.html { render :show, notice: 'Sensor updated successfully!' }
        format.json { render :show, status: :ok, location: @sensor }
      else
        format.html { render :edit }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    name = @sensor.name
    @sensor.destroy

    respond_to do |format|
      format.html { redirect_to sensors_path, notice: "Sensor \"#{name}\" removed successfully." }
      format.json { head :no_content }
    end
  end

  private

  def set_sensor
    id = params[:id]

    if id.to_i.to_s == id
      @sensor = Sensor.find_by_any_id(id)
    else
      @sensor = Sensor.find_by_manufacturer_id(id)
    end
  end

  def sensor_params(*filters)
    params.require(:sensor).permit(:name, :manufacturer_id, :active, :room_id, :sensor_type_id, filters)
  end

  def clean_sensor_type_data_from_params(params)
    sensor_type = params.delete(:sensor_type)
    if sensor_type.nil? or not params.fetch(:sensor_type_id, nil).nil?
      logger.debug 'No sensor type data found in params or the sensor_type_id param was present.
                    Nothing to do...'
      return params
    end

    manufacturer = sensor_type.fetch(:manufacturer, nil)
    model = sensor_type.fetch(:model, nil)
    sensor_type = SensorType.find_by(:manufacturer => manufacturer, :model => model)
    if sensor_type.nil?
      logger.debug "Could not find a Sensor Type with manufacturer = \"#{manufacturer}\"
                    and model = \"#{model}\".  Creating it.."
      sensor_type = SensorType.new(:model => model, :manufacturer => manufacturer)
      sensor_type.save
    end
    params[:sensor_type_id] = sensor_type.id
    params
  end
end
