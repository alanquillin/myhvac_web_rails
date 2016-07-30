class MeasurementType < ApplicationRecord
  has_many :measurements

  validates_presence_of :name
end
