class CreateUserAdminRoles < ActiveRecord::Migration
  def change
    create_table :user_admin_roles do |t|
      t.string :name, :null => false, :limit => 10
    end
  end
end
