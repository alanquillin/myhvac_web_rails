class Measurement < ApplicationRecord
  belongs_to :measurement_type
  belongs_to :sensor

  validates_presence_of :data

  scope :temperatures, lambda { joins(:measurement_type).where(:measurement_types => {:name => 'Temperature'}) }
  scope :humidities, lambda { joins(:measurement_type).where(:measurement_types => {:name => 'Humidity'}) }

  default_scope lambda { order('recorded_date DESC') }
end
