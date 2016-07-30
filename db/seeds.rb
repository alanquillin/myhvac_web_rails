# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Room.create(:name=>'Master Bedroom', :active=>true)
Room.create(:name=>'Dining Room', :active=>true)
Room.create(:name=>'Living Room', :active=>true)
Room.create(:name=>'Kitchen', :active=>true)
Room.create(:name=>'Garage')

MeasurementType.create(:name=>'Temperature')
MeasurementType.create(:name=>'Humidity')

SensorType.create(:model=>'Photon', :manufacturer=>'Particle')
SensorType.create(:model=>'Uno', :manufacturer=>'Arduino')
