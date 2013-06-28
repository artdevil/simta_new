class UserRole < ActiveRecord::Base
  #relation
  has_many :user
  attr_accessible :name
end
