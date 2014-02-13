class CreateAdvisorsSchedules < ActiveRecord::Migration
  def change
    create_table :advisors_schedules do |t|
      t.integer :user_id
      t.string :monday, :default => "-"
      t.string :tuesday, :default => "-"
      t.string :wednesday, :default => "-"
      t.string :thursday, :default => "-"
      t.string :friday, :default => "-"
      t.timestamps
    end
  end
end
