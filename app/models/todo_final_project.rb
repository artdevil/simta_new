class TodoFinalProject < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  #relation
  belongs_to :final_project
  belongs_to :user
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessible :final_project_id, :issue_number, :message, :slug, :status, :title, :user_id, :attachments_attributes
  
  #validation
  validates_presence_of :message, :final_project_id, :title, :user_id
  # validate :check_user_status, :on => :create
  
  scope :open_issue, lambda{where(:status => false)}
  scope :close_issue, lambda{where(:status => true)}
  
  #callback
  before_create :set_issue_number
  after_create :set_notification
  
  private
    def check_user_status
      if self.user.user_role_id == 1 and self.user.students_status != 3
        errors.add(:user, "Not Authorized")
      elsif self.user.user_role_id == 2 and (self.final_project.advisor_1_id != self.user_id or self.final_project.advisor_2_id != self.user_id)
        errors.add(:user, "Not Authorized")
      end
    end
    
    def set_issue_number
      self.issue_number = self.final_project.todo_final_projects.size + 1
    end
  
    def set_notification
      if self.user.user_role_id == 1
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.advisor_1_id, :message => "Membuat to do baru")
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.advisor_2_id, :message => "Membuat to do baru")
      elsif self.user.user_role_id == 2 and self.user_id == self.final_project.advisor_1_id
        #for student
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.user_id, :message => "Membuat to do baru")
        #for advisor 2
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.advisor_2_id, :message => "Membuat to do baru")
      elsif self.user.user_role_id == 2 and self.user_id == self.final_project.advisor_2_id
        #for student
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.user_id, :message => "Membuat to do baru")
        #for advisor 2
        self.notifications.create(:sender_id => self.user_id, :recipient_id => self.final_project.advisor_2_id, :message => "Membuat to do baru")
      end
    end  
end
