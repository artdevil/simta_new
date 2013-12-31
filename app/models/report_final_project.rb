class ReportFinalProject < ActiveRecord::Base
  belongs_to :final_project
  belongs_to :user
  attr_accessible :final_project_id, :note, :user_id
  validates_presence_of :final_project_id, :note, :user_id
  
  scope :advisor_progress, lambda{|user| where{(user_id == user)}}
end
