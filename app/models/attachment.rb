class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, :polymorphic => true 
  
  #upload image
  mount_uploader :file, FileUploader
  
  attr_accessible :attachmentable_id, :attachmentable_type, :file
  
  validates_presence_of :file
end
