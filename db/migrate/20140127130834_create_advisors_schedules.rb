class CreateAdvisorsSchedules < ActiveRecord::Migration
  def change
    create_table :advisors_schedules do |t|
      t.integer :user_id
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.timestamps
    end
  end
end
