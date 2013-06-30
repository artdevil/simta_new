class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :notifiable_type
      t.integer :notifiable_id
      t.string :message
      t.boolean :read, :null => false, :default => false
      t.timestamps
    end
  end
end
