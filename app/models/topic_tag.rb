class TopicTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :advisor_topic_tag, :class_name => "User", :foreign_key => "advisor_id"
  has_many :attachments, :as => :attachmentable , :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  attr_accessible :status, :topic_id, :user_id, :title_recommended, :description_recommended, :advisor_id, :attachments_attributes
  
  #validate
  validates_presence_of :topic_id, :title_recommended, :description_recommended
  validate :checking_topic_status, :check_advisor_status, :check_student_status, :on => :create
  
  #callback
  before_create :checking_user_tag, :if => Proc.new{ self.user.is_student? }
  after_update :set_notification_to_student, :if => Proc.new{ self.status == false || self.status == true}
  after_update :update_user_status_cancel, :if => Proc.new{ self.status == false}
  after_create :set_notification_for_lecture
  after_create :update_user_status
  
  #scope
  default_scope where(:status => nil)
  
  def self.get_empty_topic_with_key_id
    where(:status => nil).first.topic.user.keyid
  end
  
  def update_status_true
    self.update_column(:status, true)
  end
  
  def check_advisor_status
    advisor_status = Topic.find(self.topic_id).user.advisors_status
    if advisor_status.coordinator >= advisor_status.max_coordinator
      errors.add(:base, "Advisor reach max quota")
    end
  end
  
  def check_student_status
    student = User.find(self.user_id)
    if !student.students_status.is_no_status? and !student.topic_tags.blank?
      errors.add(:base, "student has topic tag or not on proposal status")
    end
  end
  
  private
    def checking_user_tag
      self.advisor_id = self.topic.user.id
    end
    
    def checking_topic_status
      unless self.topic.status
        errors.add(:base, "not authorized for tag topic")
      end
    end
    
    def set_notification_for_lecture
      notification = self.notifications.new(:sender_id => self.user_id, :recipient_id => self.topic.user.id, :message => "Mengirimkan anda sebuah konfirmasi pengambilan topik")
      notification.save
    end
    
    def set_notification_to_student
      notification = self.notifications.new(:sender_id => self.advisor_id, :recipient_id => self.user_id, :message => "#{self.status == true ? 'permintaan topik TA telah disetujui' : 'permintaan topik TA dibatalkan'}")
      notification.save
    end
    
    def update_user_status
      self.user.students_status.update_column(:status, 1)
    end
    
    def update_user_status_cancel
      self.user.students_status.update_column(:status, 0)
    end
    
end
