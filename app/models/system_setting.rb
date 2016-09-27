class SystemSetting < ApplicationRecord
  belongs_to :mode, foreign_key: 'system_mode_id', class_name: 'SystemMode'
  belongs_to :current_program,  foreign_key: 'current_program_id', class_name: 'Program'

  default_scope lambda { where('system_settings.active = ?', true) }

  scope :inactive, lambda { where('system_settings.active = ?', true) }
end
