class AttachmentAdmin < ActiveRecord::Base
  belongs_to :attachment_adminable, :polymorphic => true 
  
  attr_accessible :attachment_adminable_id, :attachment_adminable_type, :file
  
  #upload image
  mount_uploader :file, FileAdminUploader
  
  validates_presence_of :file
end
