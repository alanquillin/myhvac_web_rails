class Program < ApplicationRecord
  has_many :schedules, class_name: 'ProgramSchedule'

  validates_presence_of :name
end
