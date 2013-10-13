class CreateFinalProjects < ActiveRecord::Migration
  def change
    create_table :final_projects do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :advisor_1_id
      t.integer :advisor_2_id
      t.string :advisor_2_name
      t.string :title
      t.text :description
      t.integer :progress, :null => false, :default => 0
      t.boolean :finished, :null => false, :default => false
      t.timestamps
    end
  end
end
