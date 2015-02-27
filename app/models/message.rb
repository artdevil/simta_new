class Message < ActiveRecord::Base
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  is_private_message
  
  attr_accessor :recipient_name
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  #attr_accessor :to
  attr_accessible :recipient_name, :recipient_id, :subject, :body, :sender, :attachments_attributes
  validates_presence_of :subject, :body
  validates_presence_of :recipient_name, :on => :create
  #callback
  after_create :send_notification
  
  private
    def send_notification
      notification = self.notifications.new(:sender_id => self.sender_id, :recipient_id => self.recipient_id, :message => "Mengirimkan anda sebuah pesan")
      notification.save
    end
  
end