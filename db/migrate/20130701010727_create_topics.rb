class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.boolean :status, :default => true, :null => false
      t.integer :proposals_count, :default => 0

      t.timestamps
    end
  end
end
