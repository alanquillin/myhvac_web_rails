class CreateProgramsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :programs do |t|
      t.string :name, null: false, index:true, unique: true

      t.timestamps
    end

    create_table :program_schedules do |t|
      t.integer :program_id, null: false, index: true
      t.float :cool_temp
      t.float :heat_temp
      t.integer :days_of_week_bin_aggr, null: false, comment: 'This value is a binary representation of the days of week for the schedule.  Sunday=1 -> Saturday=64.  Ex: Monday, Wednesday, Firday = 42, Sunday-Saturday=127'
      t.time :time_of_day, null: false

      t.timestamps
    end

    create_table :system_settings do |t|
      t.integer :current_program_id
      t.integer :system_mode_id, null: false
      t.float :cool_temp
      t.float :heat_temp
      t.boolean :active, null: false, index: true

      t.timestamps
    end

    create_table :system_modes do |t|
      t.string :name, null: false, index: true, unique: true
      t.boolean :has_programs, null: false, index: true, default: false

      t.timestamps
    end

    add_foreign_key :system_settings, :programs, column: :current_program_id, name: 'fk_rails_system_settings_to_programs', on_delete: :restrict
    add_foreign_key :system_settings, :system_modes, name: 'fk_rails_system_settings_to_system_modes', on_delete: :restrict
    add_foreign_key :program_schedules, :programs, name: 'fk_rails_program_schedules_to_programs', on_delete: :cascade
  end
end
