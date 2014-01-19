class ReportFinalProject < ActiveRecord::Base
  belongs_to :final_project
  belongs_to :user
  attr_accessible :final_project_id, :note, :user_id
  validates_presence_of :final_project_id, :note, :user_id
  validate :check_minimal_time
  
  scope :advisor_progress, lambda{|user| where{(user_id == user)}}
  
  def check_minimal_time
    if DateTime.now <= last_report_final(self).created_at + AdminSetting.time.days
      errors.add(:note, "Waktu Minimal Bimbingan Tidak Memenuhi (minimal #{AdminSetting.time.to_s} hari)")
    end
  end
  
  def last_report_final report_final
    ReportFinalProject.where(:user_id => report_final.user_id, :final_project_id => report_final.final_project_id).last
  end
end
