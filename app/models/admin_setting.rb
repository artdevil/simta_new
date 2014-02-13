class AdminSetting < ActiveRecord::Base
  attr_accessible :guidance_time_s1_telecommunication, :guidance_time_s1_extension_telecommunication, :guidance_time_d3_telecommunication, :guidance_time_s1_computer_system
  
  def self.setting_time_minimal
    [['1 Minggu', 7],['4 Hari', 4]]
  end
  
  def self.time(faculty)
    case faculty.name
    when "S1-Teknik Elektro dan komunikasi"
      AdminSetting.first.guidance_time_s1_telecommunication
    when "S1 Pindahan-Teknik Elektro dan komunikasi"
      AdminSetting.first.guidance_time_s1_extension_telecommunication
    when "D3-Teknik Elektro dan komunikasi"
      AdminSetting.first.guidance_time_d3_telecommunication
    when "S1-Sistem Komputer"
       AdminSetting.first.guidance_time_s1_computer_system
    end
  end
end
