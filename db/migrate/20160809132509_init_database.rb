class InitDatabase < ActiveRecord::Migration[5.0]
  def change

    create_table :rooms do |t|
      t.string :name, null: false, index:true, limit:50
      t.boolean :active, default: false
      t.float :weight, default: 1.0

      t.timestamps
    end

    create_table :sensor_types do |t|
      t.string :model, null: false, index:true, limit:50
      t.string :manufacturer, null: false, index:true, limit:50

      t.timestamps
    end

    create_table :sensors do |t|
      t.string :name, null: false, limit:255
      t.string :manufacturer_id, index: true, limit:255
      t.integer :sensor_type_id, index: true, null: false
      t.integer :room_id, index: true
      t.boolean :active, default: false

      t.timestamps
    end

    create_table :measurement_types do |t|
      t.string :name, null: false, limit:15

      t.timestamps
    end

    create_table :measurements do |t|
      t.integer :sensor_id, null: false
      t.integer :measurement_type_id, null: false
      t.float :data, null: false
      t.timestamp :recorded_date, null: false

      t.timestamps
    end

    add_foreign_key :sensors, :rooms, name: 'fk_rails_sensors_to_rooms', on_delete: :restrict
    add_foreign_key :sensors, :sensor_types, name: 'fk_rails_sensors_to_sensor_types', on_delete: :restrict
    add_foreign_key :measurements, :measurement_types, name: 'fk_rails_measurements_to_measurement_types', on_delete: :restrict
    add_foreign_key :measurements, :sensors, name: 'fk_rails_measurements_to_sensors', on_delete: :cascade
  end
end
