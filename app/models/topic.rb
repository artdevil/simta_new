class Topic < ActiveRecord::Base
  acts_as_taggable
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  default_scope {order('created_at desc')}
  
  #relation
  belongs_to :user
  has_many :proposals, :dependent => :destroy
  has_many :attachments, :as => :attachmentable , :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :topic_tags
  
  attr_accessible :description, :proposals_count, :status, :tag_list, :title, :user_id, :attachments_attributes, :slug
  
  #validates
  validates_presence_of :description, :title, :user_id
  validate :check_user_role, :if => :new_record?
  
  #callback
  
  private
    def check_user_role
      unless self.user.user_role_id == 2
        errors.add(:user_id, "not authorized user")
      end
    end
end
