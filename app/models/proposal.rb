class Proposal < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_proposals, :dependent => :destroy
  
  
  attr_accessor :advisor_2_name
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :progress, :title, :topic_id, :user_id, :advisor_2_name
  
  #validate
  validates_presence_of :advisor_1_id, :advisor_2_id, :title, :topic_id, :user_id, :advisor_2_name
  validate :check_user_advisor_2_input
  
  #callback
  after_create :send_message_to_student_and_advisor_2
  after_create :set_quota
  after_create :update_student_status
  
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
end
