class Document < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :user_id, :document_type, :file, :name
  
  #validation
  validates_presence_of :file, :name, :document_type
  validate :cek_user_status
  
  #upload document
  mount_uploader :file, DocumentUploader
  
  scope :ta, where(:document_type => "tugas akhir")
  scope :proposal, where(:document_type => "proposal")
  scope :miss, where(:document_type => "lain-lain")
  
  def document_type_file
    ['tugas akhir', 'proposal','lain-lain']
  end
  
  def cek_user_status
    unless user.user_role_id == 3 or user.user_role_id == 4
      errors.add(:base, "you are not autorized")
    end
  end
end
