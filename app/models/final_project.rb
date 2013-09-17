class FinalProject < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :proposal
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_final_projects
  has_many :report_final_projects
  
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :finished, :progress, :proposal_id, :title, :user_id
  
  #validation
  validates_presence_of :advisor_1_id, :advisor_2_id, :description, :proposal_id, :title, :user_id
  validates_numericality_of :progress, :only_integer =>true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "invalid number"
  
  #callback
  after_update :update_user_status_to_finished, :if => Proc.new{ self.finished }
  after_update :set_notification_100, :if => Proc.new{ self.progress == 100 and !self.finished }
  
  scope :advisor_student, lambda{|f| where{(advisor_1_id == f.id or advisor_2_id == f.id) and finished == false}}
  
  private
    def set_notification_100
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Final Project anda telah selesai. Silahkan mengajukan diri untuk sidang TA")
      notification.save
    end
    
    def update_user_status_to_finished
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Selamat! Final Project anda telah selesai")
      notification.save
      self.user.students_status.update_column(:status, 4)
    end
end
