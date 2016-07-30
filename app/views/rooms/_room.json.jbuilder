json.extract! room, :id, :name, :active, :weight, :sensors, :created_at, :updated_at
json.url room_url(room, format: :json)