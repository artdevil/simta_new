class AddUserToReportFinalProjects < ActiveRecord::Migration
  def change
    add_column :report_final_projects, :user_id, :integer
  end
end
