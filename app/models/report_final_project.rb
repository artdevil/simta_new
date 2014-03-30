class ReportFinalProject < ActiveRecord::Base
  # public activity
  include PublicActivity::Model
  tracked owner: ->(controller, model) { model.user }
  tracked recipient: ->(controller, model) { model.final_project }
  
  belongs_to :final_project
  belongs_to :user
  attr_accessible :final_project_id, :note, :user_id
  validates_presence_of :final_project_id, :note, :user_id
  validate :check_minimal_time
  
  scope :advisor_progress, lambda{|user| where{(user_id == user)}}
  
  def check_minimal_time
    last_report = last_report_final(self)
    if last_report.present?
      timing = AdminSetting.time(self.final_project.user.faculty)
      if DateTime.now <= last_report.created_at + timing.days
        errors.add(:note, "Waktu Minimal Bimbingan Tidak Memenuhi (minimal #{timing.to_s} hari)")
      end
    end
  end
  
  def last_report_final report_final
    ReportFinalProject.where(:user_id => report_final.user_id, :final_project_id => report_final.final_project_id).last
  end
end
