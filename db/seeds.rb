# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Room.create(:name=>'Master Bedroom', :active => true)
Room.create(:name=>'Dining Room', :active => true)
Room.create(:name=>'Living Room', :active => true)
Room.create(:name=>'Kitchen', :active => true)
Room.create(:name=>'Garage')

MeasurementType.create(:name => 'Temperature')
MeasurementType.create(:name => 'Humidity')

SensorType.create(:model =>'Photon', :manufacturer => 'Particle')
SensorType.create(:model =>'Uno', :manufacturer => 'Arduino')

offMode = SystemMode.create(:name => 'Off')
SystemMode.create(:name => 'Manual')
SystemMode.create(:name => 'Auto', :has_programs => true)

SystemSetting.create(:system_mode_id => offMode.id, :active => true)

summer = Program.create(:name => 'Summer')
fall = Program.create(:name => 'Fall')
winter = Program.create(:name => 'Winter')
spring = Program.create(:name => 'Spring')

ProgramSchedule.create(:program_id => summer.id, :days_of_week_bin_aggr => 127, :cool_temp => 74.0, :time_of_day => Time.parse('08:00:00'))
ProgramSchedule.create(:program_id => summer.id, :days_of_week_bin_aggr => 127, :cool_temp => 72.0, :time_of_day => Time.parse('17:00:00'))
ProgramSchedule.create(:program_id => summer.id, :days_of_week_bin_aggr => 127, :cool_temp => 70.0, :time_of_day => Time.parse('20:00:00'))

ProgramSchedule.create(:program_id => winter.id, :days_of_week_bin_aggr => 127, :heat_temp => 66.0, :time_of_day => Time.parse('08:00:00'))
ProgramSchedule.create(:program_id => winter.id, :days_of_week_bin_aggr => 127, :heat_temp => 68.0, :time_of_day => Time.parse('20:00:00'))

[spring, fall].each do |s|
  ProgramSchedule.create(:program_id => s.id, :days_of_week_bin_aggr => 127, :heat_temp => 66.0, :cool_temp => 74.0, :time_of_day => Time.parse('08:00:00'))
  ProgramSchedule.create(:program_id => s.id, :days_of_week_bin_aggr => 127, :heat_temp => 66.0,:cool_temp => 72.0, :time_of_day => Time.parse('17:00:00'))
  ProgramSchedule.create(:program_id => s.id, :days_of_week_bin_aggr => 127, :heat_temp => 68.0, :cool_temp => 70.0, :time_of_day => Time.parse('20:00:00'))
end
