class AddStatusToExaminer < ActiveRecord::Migration
  def change
    add_column :examiners, :finished, :boolean
    add_column :examiners, :revision, :boolean
    add_column :examiners, :revision_date, :date
  end
end
