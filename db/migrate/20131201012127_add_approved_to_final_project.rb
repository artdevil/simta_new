class AddApprovedToFinalProject < ActiveRecord::Migration
  def change
    add_column :final_projects, :document_final_project, :string
    add_column :final_projects, :document_advisor_testers, :string
  end
end
