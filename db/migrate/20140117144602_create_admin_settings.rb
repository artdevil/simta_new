class CreateAdminSettings < ActiveRecord::Migration
  def self.up
    create_table :admin_settings do |t|
      t.integer :guidance_time_minimal, :default => 7
      t.timestamps
    end
    AdminSetting.create
  end
  
  def self.down
    drop_table :admin_settings
  end
end
