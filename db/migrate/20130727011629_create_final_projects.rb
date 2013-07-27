class CreateFinalProjects < ActiveRecord::Migration
  def change
    create_table :final_projects do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :advisor_1_id
      t.integer :advisor_2_id
      t.string :title
      t.text :description
      t.integer :progress
      t.boolean :finished

      t.timestamps
    end
  end
end
