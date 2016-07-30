class SensorType < ApplicationRecord
  has_many :sensors

  validates_presence_of :model
  validates_presence_of :manufacturer

  def model_with_manufacturer
    "#{model} (#{manufacturer})"
  end
end
