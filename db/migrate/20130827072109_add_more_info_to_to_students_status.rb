class AddMoreInfoToToStudentsStatus < ActiveRecord::Migration
  def change
    add_column :students_statuses, :department, :string
    add_column :students_statuses, :prodi, :string
    add_column :students_statuses, :address, :string
    add_column :students_statuses, :phone, :string
  end
end
