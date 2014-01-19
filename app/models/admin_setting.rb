class AdminSetting < ActiveRecord::Base
  attr_accessible :guidance_time_minimal
  
  def self.setting_time_minimal
    [['1 Minggu', 7],['4 Hari', 4]]
  end
  
  def self.time
    AdminSetting.first.guidance_time_minimal
  end
end
