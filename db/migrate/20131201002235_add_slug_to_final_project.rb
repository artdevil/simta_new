class AddSlugToFinalProject < ActiveRecord::Migration
  def change
    add_column :final_projects, :slug, :string, :unique => true
  end
end
