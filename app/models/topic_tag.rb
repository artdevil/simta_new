class TopicTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  has_many :attachments, :as => :attachmentable , :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  attr_accessible :status, :topic_id, :user_id, :title_recommended, :description_recommended
  
  validates_presence_of :topic_id, :user_id, :title_recommended, :description_recommended
  
  before_save :checking_user_tag, :on => :create
  before_save :checking_topic_status
  after_create :set_notification_for_lecture
  
  private
    def checking_user_tag
      if self.user.user_role_id == 1
        return true
      else
        self.errors.add(:user, "not authorized user")
        return false
      end
    end
    
    def checking_topic_status
      if self.topic.status
        return true
      else
        self.errors.add(:topic_id, "not authorized for tag topic")
        return false
      end
    end
    
    def set_notification_for_lecture
      notification = self.notifications.new(:sender_id => self.user_id, :recipient_id => self.topic.user.id, :message => "Mengirimkan anda sebuah konfirmasi pengambilan topik")
      notification.save
    end
end
