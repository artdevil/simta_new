class AddPrimaryAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_account, :boolean
  end
end
