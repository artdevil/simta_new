class FinalProject < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  #relation
  belongs_to :user
  belongs_to :proposal
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_final_projects, :dependent => :destroy
  has_many :report_final_projects, :dependent => :destroy
  has_many :examiners, :dependent => :destroy
  
  attr_accessible :advisor_1_id, :advisor_2_id, :advisor_2_name, :description, :finished, :progress, :proposal_id, :title, :user_id, :document_final_project, :document_revision_final_project
  
  #upload image
  mount_uploader :document_final_project, DocumentFinalProjectUploader
  mount_uploader :document_revision_final_project, DocumentRevisionFinalProjectUploader
  
  #validation
  validate :check_user_status, :on => :create
  validates_presence_of :advisor_1_id, :advisor_2_id, :description, :proposal_id, :title, :user_id
  validate :check_advisor_report, :on => :update, :if => Proc.new{ self.progress == 100 }
  validates_numericality_of :progress, :only_integer =>true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "invalid number"
  
  #callback
  after_update :update_user_status_to_finished, :if => Proc.new{ self.finished }
  after_update :set_notification_100, :if => Proc.new{ self.progress == 100 and !self.finished }
  before_update :check_change_advisor_2
  
  scope :advisor_student, lambda{|f| where("finished = false and (advisor_1_id = ? or advisor_2_id = ? )",f.id,f.id)}
  
  def check_user_access(user_id)
    if self.user_id != user_id and self.advisor_1_id != user_id and self.advisor_2_id != user_id
      return true
    else
      return false
    end
  end
  
  def is_advisor_1?(user_id)
    self.advisor_1 == user_id
  end
  
  private
    def check_change_advisor_2
      if self.advisor_2_name_changed?
        if self.advisor_2_id_changed?
          self.proposal.update_attributes(:advisor_2_id => self.advisor_2_id, :advisor_2_name => self.advisor_2_name)
        end
      end
    end
    
    def check_advisor_report
      if self.report_final_projects.advisor_progress(self.proposal.advisor_1_id).count < 8
        errors.add(:base, "Pembimbing pertama belum memenuhi final project report (masih kurang dari 8)")
      elsif self.proposal.advisor_2_id.present? and self.report_final_projects.advisor_progress(self.proposal.advisor_2_id).count < 8 
        errors.add(:base, "Pembimbing kedua belum memenuhi final project report (masih kurang dari 8)")
      end
    end
  
    def check_user_status
      if !self.user.students_status.is_working_proposal? and !self.user.proposal.present? and !self.user.proposal.finished? 
        errors.add(:base, "user can't create final project")
      end
    end
    
    def set_notification_100
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Final Project anda telah selesai. Silahkan mengupload buku dan mengajukan diri untuk sidang TA")
      notification.save
      self.user.students_status.update_column(:status, 4)
      self.examiners.create
    end
    
    def update_user_status_to_finished
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Selamat! Final Project anda telah selesai")
      notification.save
      self.user.students_status.update_column(:status, 6)
      update_advisor_decrease
    end
    
    def update_advisor_decrease
      self.advisor_1.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator - 1)
      if self.advisor_2.present?
        self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator - 1)
      end
    end
end
