class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, :polymorphic => true 
  belongs_to :user
  
  #upload image
  mount_uploader :file, FileUploader
  
  attr_accessible :attachmentable_id, :attachmentable_type, :file, :user_id
  
  validates_presence_of :file, :user_id
end
