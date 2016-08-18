class Room < ApplicationRecord
  has_many :sensors

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :active, lambda { where('rooms.active') }
  scope :inactive, lambda { where('NOT rooms.active') }

  def current_temp
    cnt = 0
    temp_total = 0.0
    sensors.active.each do |sensor|
      c_temp = sensor.current_temp
      if not c_temp.nil?
        cnt += 1
        temp_total += c_temp
      end
    end

    return nil unless cnt > 0

    temp_total / cnt
  end

  def latest_temp_rec_date
    latest_temp_rec_dates = sensors.map {|s| s.latest_temp_rec_date}.compact

    return nil if latest_temp_rec_dates.empty?

    latest_temp_rec_dates.max
  end
end
