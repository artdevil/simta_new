class CreateAdminSettings < ActiveRecord::Migration
  def self.up
    create_table :admin_settings do |t|
      t.integer :guidance_time_s1_extension_telecommunication, :default => 7
      t.integer :guidance_time_s1_telecommunication, :default => 7
      t.integer :guidance_time_d3_telecommunication, :default => 7
      t.integer :guidance_time_s1_computer_system, :default => 7
      t.timestamps
    end
    AdminSetting.create
  end
  
  def self.down
    drop_table :admin_settings
  end
end
