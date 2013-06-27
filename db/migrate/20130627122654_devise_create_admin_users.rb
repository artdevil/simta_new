class DeviseCreateAdminUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create a default user
    AdminUser.create!(:username => 'mohammad ramdhani',:keyid => "02730260-1", :password => 'password',:user_admin_role_id => 1, :password_confirmation => 'password') if direction == :up
    AdminUser.create!(:username => 'Admin',:keyid => "02730261-1", :password => 'password',:user_admin_role_id => 2, :password_confirmation => 'password') if direction == :up
  end

  def change
    create_table(:admin_users) do |t|
      ## Database authenticatable
      t.string :username, :null => false
      t.string :keyid, :null => false, :limit => 10
      t.string :user_admin_role_id
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token


      t.timestamps
    end

    # add_index :admin_users, :email,                :unique => true
    add_index :admin_users, :keyid,                :unique => true
    add_index :admin_users, :reset_password_token, :unique => true
    # add_index :admin_users, :confirmation_token,   :unique => true
    # add_index :admin_users, :unlock_token,         :unique => true
    # add_index :admin_users, :authentication_token, :unique => true
  end
end
