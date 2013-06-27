class UserAdminRole < ActiveRecord::Base
  #relation
  has_many :admin_users
  attr_accessible :name
end
