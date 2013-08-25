class News < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  #relation
  belongs_to :admin_user
  has_many :attachment_admins, :as => :attachment_adminable, :dependent => :destroy
  accepts_nested_attributes_for :attachment_admins, allow_destroy: true
  
  
  attr_accessible :admin_user_id, :description, :title, :attachment_admins_attributes
  
  #validation
  validates_presence_of :description, :title
  
  #scope
  default_scope order('created_at desc')
end
