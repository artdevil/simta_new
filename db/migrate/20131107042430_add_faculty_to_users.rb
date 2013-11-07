class AddFacultyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :faculty_id, :integer
  end
end
