class Program < ApplicationRecord
  has_many :schedules, class_name: 'ProgramSchedule'

  validates_presence_of :name
  validates_uniqueness_of :name
end
