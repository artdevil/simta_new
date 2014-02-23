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
  accepts_nested_attributes_for :proposals, :reject_if => proc { |attributes| attributes['title'].blank? && attributes['advisor_2_name'].blank? && attributes['username'].blank?}, :allow_destroy => true
  has_many :topic_tags
  
  attr_accessible :description, :proposals_count, :status, :tag_list, :title, :proposals_attributes, :user_id, :attachments_attributes, :slug
  
  #validates
  validates_presence_of :description, :title, :user_id
  validate :check_user_role, :if => :new_record?
  validate :check_number_proposal, :if => :new_record?
  before_save :set_token_for_proposal, :if => Proc.new{proposals.reject(&:persisted?).count > 1}
  
  def set_token_for_proposal
    Rails.logger.info('running token')
    token_generate = generate_token
    proposals.reject(&:persisted?).each do |proposal|
      proposal.group_token = token_generate
    end
  end
  
  #callback
  def check_number_proposal
    if proposals.reject(&:persisted?).size > 3
      self.errors.add(:base, "Jumlah mahasiswa se-group tidak boleh lebih dari 3")
    end
  end
  
  def generate_token
    token = loop do
      random_token = SecureRandom.hex(4)
      break random_token unless Proposal.exists?(group_token: random_token)
    end
    return token
  end
  
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
      unless self.user.is_advisor? or self.user.is_kaprodi?
        errors.add(:user_id, "not authorized user")
      end
    end
    
    
end
