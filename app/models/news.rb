class News < ActiveRecord::Base
  #relation
  belongs_to :admin_user
  has_many :attachment_admins, :as => :attachment_adminable, :dependent => :destroy
  accepts_nested_attributes_for :attachment_admins, allow_destroy: true
  
  
  attr_accessible :admin_user_id, :description, :title, :attachment_admins_attributes
  
  validates_presence_of :description, :title
  
end
