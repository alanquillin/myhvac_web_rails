json.extract! sensor, :id, :name, :active, :sensor_type, :created_at, :updated_at
json.url sensor_url(sensor, format: :json)