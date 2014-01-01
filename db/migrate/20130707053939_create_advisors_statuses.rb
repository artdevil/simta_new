class CreateAdvisorsStatuses < ActiveRecord::Migration
  def change
    create_table :advisors_statuses do |t|
      t.integer :user_id, :null => false
      t.integer :max_coordinator, :default => 5, :null => false
      t.integer :coordinator, :default => 0, :null => false
      t.string :skills
      t.timestamps
    end
  end
end
