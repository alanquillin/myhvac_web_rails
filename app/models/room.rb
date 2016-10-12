class Room < ApplicationRecord
  has_many :sensors
  has_many :measurements, :through => :sensors

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :active, lambda { where('rooms.active') }
  scope :inactive, lambda { where('NOT rooms.active') }

  def current_temp
    measurement = measurements.temperatures.first
    measurement.nil? ? nil : measurement.data
  end

  def latest_temp_rec_date
    measurement = measurements.temperatures.first
    measurement.nil? ? nil : measurement.recorded_date
  end

  def show_stale_measurement_alert?
    time_since_last_m = minutes_since_last_meaurement

    return false if time_since_last_m.nil?

    time_since_last_m > Settings.stale_measurement_threshold_min
  end

  def minutes_since_last_meaurement
    rec_dt = latest_temp_rec_date

    return nil if rec_dt.nil?

    ((Time.now.utc - rec_dt) / 60).floor
  end
end
