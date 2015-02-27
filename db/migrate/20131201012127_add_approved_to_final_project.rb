class AddApprovedToFinalProject < ActiveRecord::Migration
  def change
    add_column :final_projects, :document_final_project, :string
    add_column :final_projects, :document_revision_final_project, :string
  end
end
