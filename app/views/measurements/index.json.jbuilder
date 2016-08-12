json.measurements(@measurements) do |measurement|
  json.partial! 'measurements/measurement', measurement: measurement
end
json.total @count