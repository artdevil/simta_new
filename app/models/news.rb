class News < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  #relation
  belongs_to :user
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  
  
  attr_accessible :description, :title, :attachments_attributes, :user_id
  
  #validation
  validates_presence_of :description, :title
  
  #scope
  default_scope order('created_at desc')
end
