class CreateReportFinalProjects < ActiveRecord::Migration
  def change
    create_table :report_final_projects do |t|
      t.integer :final_project_id
      t.text :note

      t.timestamps
    end
  end
end
