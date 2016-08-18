class Sensor < ApplicationRecord
  before_save :downcase_fields
  before_update :downcase_fields
  before_create :downcase_fields

  belongs_to :room, optional: true
  belongs_to :sensor_type

  has_many :measurements

  validates_presence_of :name
  validates_presence_of :manufacturer_id
  validates_uniqueness_of :manufacturer_id

  scope :active, lambda { where('sensors.active') }
  scope :inactive, lambda { where('NOT sensors.active') }

  scope :find_by_manufacturer_id, lambda { |id| where('lower(sensors.manufacturer_id) = lower(:mid)',
                                                      :mid => id.to_s) }
  scope :find_by_any_id, (lambda do |id|
    if id.to_i.to_s == id.to_s
      where('sensors.id = :sid OR lower(sensors.manufacturer_id) = lower(:mid)',
            {:sid => id.to_i, :mid => id.to_s})
    else
      find_by_manufacturer_id(id)
    end
  end)

  def current_temp
    measurement = measurements.temperatures.first
    measurement.nil? ? nil : measurement.data
  end

  def latest_temp_rec_date
    measurement = measurements.temperatures.first
    measurement.nil? ? nil : measurement.recorded_date
  end

  private

  def downcase_fields
    self.manufacturer_id.downcase!
  end
end
