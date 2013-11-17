class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :topic_id
      t.integer :user_id
      t.integer :advisor_1_id
      t.integer :advisor_2_id
      t.string :advisor_2_name
      t.string :title
      t.text :description
      t.integer :progress, :default => 0, :null => false
      t.boolean :finished, :null => false, :default => false
      t.string :exam
      t.string :events
      t.string :proposal
      t.string :decree
      t.timestamps
    end
  end
end
