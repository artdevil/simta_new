class Topic < ActiveRecord::Base
  acts_as_taggable
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  default_scope {order('created_at desc')}
  
  #relation
  belongs_to :user
  has_many :proposals
  has_many :attachments, :as => :attachmentable , :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :proposals, :reject_if => proc { |attributes| attributes['title'].blank? && attributes['advisor_2_name'].blank? && attributes['user_name'].blank?}, :allow_destroy => true
  has_many :topic_tags
  
  attr_accessible :description, :proposals_count, :status, :tag_list, :title, :proposals_attributes, :user_id, :attachments_attributes, :slug
  
  #validates
  validates_presence_of :description, :title, :user_id
  validate :check_user_role, :if => :new_record?
  
  #callback
  
  def advisor_limit_quota
    advisor_status = self.user.advisors_status
    if advisor_status.coordinator >= advisor_status.max_coordinator
      return true
    else
      return false
    end
  end
  
  private
    def check_user_role
      unless self.user.is_advisor?
        errors.add(:user_id, "not authorized user")
      end
    end
    
    
end
