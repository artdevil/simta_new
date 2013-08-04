class Proposal < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_one :final_project
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_proposals, :dependent => :destroy
  
  
  attr_accessor :advisor_2_name
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :progress, :title, :topic_id, :user_id, :advisor_2_name, :exam, :events, :proposal, :finished
  
  #validate
  validates_presence_of :advisor_1_id, :advisor_2_id, :title, :topic_id, :user_id, :advisor_2_name, :on => :create
  validate :check_user_advisor_2_input, :on => :create
  validates_numericality_of :progress, :only_integer =>true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "invalid number"
  # validates_presence_of :finished, :unless: Proc.new { |a| a.exam.blank? and a.events.blank? and a.proposal.blank? and a.progress < 100}
  
  #upload image
  mount_uploader :exam, ExamUploader
  mount_uploader :events, EventsUploader
  mount_uploader :proposal, ProposalUploader
  
  #callback
  after_create :send_message_to_student_and_advisor_2
  after_create :set_quota
  after_create :update_student_status
  after_save :set_notification_finished, :if => Proc.new{ self.progress == 100 }
  after_save :create_final_project, :if => Proc.new{ self.finished == true }
  
  scope :advisor_student, lambda{|f| where{(advisor_1_id == f.id or advisor_2_id == f.id) and finished == false}}
  
  private
     
    def check_user_advisor_2_input
      @user = User.where(:username => self.advisor_2_name, :user_role_id => 2).first
      if @user
        if @user.advisors_status.coordinator > @user.advisors_status.max_coordinator
          errors.add(:advisor_2_name, "Kuota dosen bimbingan penuh")
        end
      else
        errors.add(:advisor_2_name, "Nama dosen tidak ditemukan")
      end
    end
    
    def send_message_to_student_and_advisor_2
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Permintaan proposal anda telah disetujui")
      notification.save
      notification2 = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.advisor_2_id, :message => "Anda telah diminta untuk menjadi pembimbing proposal tugas akhir")
      notification2.save
    end
    
    def set_quota
      self.advisor_1.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator + 1)
      self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_2.advisors_status.coordinator + 1)
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
