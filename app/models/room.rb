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
end
