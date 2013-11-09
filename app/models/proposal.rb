class Proposal < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_one :final_project
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_proposals, :dependent => :destroy
  attr_accessible :advisor_1_id, :advisor_2_id, :advisor_2_name, :description, :progress, :title, :topic_id, :user_id, :advisor_2_name, :exam, :events, :proposal, :finished

  #validate
  validate :cek_user_id, :cek_status_user, :cek_advisor_1_quota, :cek_advisor_2_quota, :on => :create
  validates_presence_of :advisor_1_id, :advisor_2_name, :title, :description
  validates_numericality_of :progress, :only_integer =>true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "invalid number"
  # validates_presence_of :finished, :unless: Proc.new { |a| a.exam.blank? and a.events.blank? and a.proposal.blank? and a.progress < 100}
  
  #upload image
  mount_uploader :exam, ExamUploader
  mount_uploader :events, EventsUploader
  mount_uploader :proposal, ProposalUploader
  
  #callback
  after_create :send_message_to_student_and_advisor_2, :set_quota, :update_student_status
  after_save :set_notification_finished, :if => Proc.new{ self.progress == 100 }
  after_save :create_final_project, :if => Proc.new{ self.finished == true }
  before_destroy :set_quota_decrease
  
  scope :advisor_student, lambda{|f| where{(advisor_1_id == f.id or advisor_2_id == f.id) and finished == false}}
  
  private
    def cek_user_id
      if self.user_id.blank?
        errors.add(:base, "User can't found")
      end
    end 
    
    def cek_status_user
      if self.user_id.present?
        user_status = User.select_student(self.user_id).first.try(:students_status)
        unless user_status.status != 0 or user_status.status != 1
          errors.add(:user_name, "user not in search topic status")
        end
      end
    end
    
    def cek_advisor_1_quota
      advisor_1_status = User.select_lecture(self.advisor_1_id).first.try(:advisors_status)
      if advisor_1_status.present?
        if advisor_1_status.coordinator >= advisor_1_status.max_coordinator
          errors.add(:advisor_1_id, "Your quota is full")
        end
      else
        errors.add(:base, "can't find advisor 1")
      end
    end
    
    def cek_advisor_2_quota
      if self.advisor_2_id.present?
        advisor_2_status = User.select_lecture(self.advisor_2_id).first.try(:advisors_status)
        if advisor_2_status.present?
          if advisor_2_status.coordinator >= advisor_2_status.max_coordinator
            errors.add(:advisor_2_name, "Advisor quota is full")
          end
        else
          errors.add(:advisor_2_name, "can't find advisor 2")
        end
      end
    end
    
    def send_message_to_student_and_advisor_2
      self.notifications.create(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Permintaan proposal anda telah disetujui")
      unless self.advisor_2_id.blank?
        self.notifications.create(:sender_id => self.advisor_1_id, :recipient_id => self.advisor_2_id, :message => "Anda telah diminta untuk menjadi pembimbing proposal tugas akhir")
      end
    end
    
    def set_quota
      self.advisor_1.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator + 1)
      unless self.advisor_2_id.blank?
        self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_2.advisors_status.coordinator + 1)
      end
    end
    
    def set_quota_decrease
      self.advisor_1.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator - 1)
      unless self.advisor_2_id.blank?
        self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_2.advisors_status.coordinator - 1)
      end
    end
    
    def update_student_status
      self.user.students_status.update_column(:status, 2)
    end
    
    def set_notification_finished
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Proposal anda telah selesai silahkan unduh berkas untung sidang proposal")
      notification.save
    end
    
    def create_final_project
      final_project = FinalProject.new(:user_id => self.user_id, :advisor_1_id => self.advisor_1_id, :advisor_2_id => self.advisor_2_id, :proposal_id => self.id, :title => self.title, :description => self.description)
      if final_project.save
        notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Pengerjaan proposal telah selesai silahkan mengerjakan tugas akhir")
        notification.save
        self.user.students_status.update_column(:status, 3)
      end
    end
end
