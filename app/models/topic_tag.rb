class TopicTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :advisor_topic_tag, :class_name => "User", :foreign_key => "advisor_id"
  has_many :attachments, :as => :attachmentable , :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  attr_accessible :status, :topic_id, :user_id, :title_recommended, :description_recommended, :advisor_id
  
  #validate
  validates_presence_of :topic_id, :user_id, :title_recommended, :description_recommended
  validate :checking_topic_status
  
  #callback
  before_create :checking_user_tag, :if => Proc.new{ self.user.user_role_id == 1 }
  after_update :set_notification_to_student
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
  
  private
    def checking_user_tag
      self.advisor_id = self.topic.user.id
    end
    
    def checking_topic_status
      unless self.topic.status
        errors.add(:status, "not authorized for tag topic")
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
    
end