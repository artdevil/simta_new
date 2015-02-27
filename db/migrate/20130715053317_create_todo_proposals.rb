class CreateTodoProposals < ActiveRecord::Migration
  def change
    create_table :todo_proposals do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :issue_number
      t.string :title
      t.text :message
      t.boolean :status, :default => false, :null => false
      t.string :slug, :unique => true

      t.timestamps
    end
  end
end
