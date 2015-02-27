class UserRole < ActiveRecord::Base
  #relation
  has_many :users
  attr_accessible :name
end
