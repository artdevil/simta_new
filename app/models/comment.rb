class Comment < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  
  attr_accessible :comment, :commentable_id, :commentable_type, :user_id, :attachments_attributes
  
  #validate
  validates_presence_of :comment, :user_id
  
  default_scope order('id asc')
end
