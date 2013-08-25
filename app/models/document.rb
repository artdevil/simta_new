class Document < ActiveRecord::Base
  belongs_to :admin_user
  
  attr_accessible :admin_user_id, :document_type, :file, :name
  
  #validation
  validates_presence_of :file, :name
  
  #upload document
  mount_uploader :file, DocumentUploader
  
  scope :ta, where(:document_type => "tugas akhir")
  scope :proposal, where(:document_type => "proposal")
  scope :miss, where(:document_type => "")
  
  def self.document_type_file
    ['tugas akhir', 'proposal']
  end
end
