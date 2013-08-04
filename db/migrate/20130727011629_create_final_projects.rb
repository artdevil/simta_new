class CreateFinalProjects < ActiveRecord::Migration
  def change
    create_table :final_projects do |t|
      t.integer :proposal_id, :null => false
      t.integer :user_id, :null => false
      t.integer :advisor_1_id, :null => false
      t.integer :advisor_2_id, :null => false
      t.string :title
      t.text :description
      t.integer :progress, :null => false, :default => 0
      t.boolean :finished, :null => false, :default => false

      t.timestamps
    end
  end
end
