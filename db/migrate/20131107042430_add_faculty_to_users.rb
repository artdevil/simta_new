class AddFacultyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :text
    add_column :users, :phone, :string
    add_column :users, :faculty_id, :integer
  end
end
