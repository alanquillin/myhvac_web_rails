json.schedules(@schedules) do |schedule|
  json.partial! 'schedules/schedule', schedule:schedule
end