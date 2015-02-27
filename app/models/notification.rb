class Notification < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"
  belongs_to :notifiable, :polymorphic => true
  
  attr_accessible :message, :notifiable_id, :notifiable_type, :recipient_id, :sender_id, :read
  validates_presence_of :message, :notifiable_id, :notifiable_type, :recipient_id, :sender_id
  
  scope :count_notification_unread, lambda{|user_id| where(:recipient_id => user_id, :read => false)}
  scope :notification_all, lambda{|user_id| where(:recipient_id => user_id).order('created_at DESC')}
end
