class CreateStudentsStatuses < ActiveRecord::Migration
  def change
    create_table :students_statuses do |t|
      t.integer :user_id
      t.integer :status, :default => 0, :null => false

      t.timestamps
    end
  end
end
