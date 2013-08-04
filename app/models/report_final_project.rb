class ReportFinalProject < ActiveRecord::Base
  belongs_to :final_project
  attr_accessible :final_project_id, :note
  validates_presence_of :final_project_id, :note
end
