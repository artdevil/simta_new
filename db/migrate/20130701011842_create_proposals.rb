class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :topic_id
      t.integer :user_id
      t.integer :advisor_1_id
      t.integer :advisor_2_id
      t.string :title
      t.text :description
      
      t.integer :progress, :default => 0

      t.timestamps
    end
  end
end
