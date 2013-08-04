class CreateTodoFinalProjects < ActiveRecord::Migration
  def change
    create_table :todo_final_projects do |t|
      t.integer :final_project_id, :null => false
      t.integer :user_id, :null => false
      t.integer :issue_number
      t.string :title
      t.text :message
      t.boolean :status, :null => false, :default => false
      t.string :slug, :null => false, :unique => true

      t.timestamps
    end
  end
end
