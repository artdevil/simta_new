class TodoProposal < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  #relation
  belongs_to :proposal
  belongs_to :user
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessible :message, :proposal_id, :status, :title, :user_id, :attachments_attributes
  
  #validation
  validates_presence_of :message, :proposal_id, :title, :user_id
  # validate :check_user_status
  
  scope :open_issue, lambda{where(:status => false)}
  scope :close_issue, lambda{where(:status => true)}
  
  #callback
  before_create :set_issue_number
  after_create :set_notification
  
  private
  
    def shared_todo_proposal
      Proposal.where('id != ? and group_token = ? ',self.proposal.id, self.proposal.group_token)
    end
    
    def check_user_status
      if self.user.is_student? and !self.user.students_status.is_working_proposal?
        errors.add(:user, "Not Authorized")
      elsif self.user.is_advisor? and (self.proposal.advisor_1_id != self.user_id or self.proposal.advisor_2_id != self.user_id)
        errors.add(:user, "Not Authorized")
      end
    end
    
    def set_issue_number
      self.issue_number = self.proposal.todo_proposals.size + 1
    end
    
    def set_notification
      if self.user.is_student?
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.advisor_1_id, :message => "Membuat to do baru")
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.advisor_2_id, :message => "Membuat to do baru")
      elsif self.user.is_advisor? and self.user_id == self.proposal.advisor_1_id
        #for student
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.user_id, :message => "Membuat to do baru")
        #for advisor 2
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.advisor_2_id, :message => "Membuat to do baru")
      elsif self.user.is_advisor? and self.user_id == self.proposal.advisor_2_id
        #for student
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.user_id, :message => "Membuat to do baru")
        #for advisor 2
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.proposal.advisor_2_id, :message => "Membuat to do baru")
      end
      
      # for todos group
      if self.proposal.group_token.present?
        shared_todo_proposal.each do |proposal|
          self.notifications.create(:sender_id => self.user_id, :recipient_id => proposal.user_id, :message => "Membuat to do baru")
        end
      end
    end       
end
