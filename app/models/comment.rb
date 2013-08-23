class Comment < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :attachments, :as => :attachmentable, :dependent => :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
  
  attr_accessible :comment, :commentable_id, :commentable_type, :user_id, :attachments_attributes
  
  #validate
  validates_presence_of :comment, :user_id
  
  default_scope order('id asc')
  
  #callback
  after_create :set_notification
  
  private
    def set_notification
      if self.commentable_type == "TodoProposal"
        if self.user.user_role_id == 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_1_id, :message => "Mengomentari todos proposal")
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_2_id, :message => "Mengomentari todos proposal")
        elsif self.user.user_role_id == 2 and self.commentable_type == "TodoProposal" and self.user_id == self.commentable.proposal.advisor_1_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.user_id, :message => "Mengomentari todos proposal")
          #for advisor 2
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_2_id, :message => "Mengomentari todos proposal")
        elsif self.user.user_role_id == 2 and self.commentable_type == "TodoProposal" and self.user_id == self.commentable.proposal.advisor_2_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.user_id, :message => "Mengomentari todos proposal")
          #for advisor 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_1_id, :message => "Mengomentari todos proposal")
        end
      elsif self.commentable_type == "TodoFinalProject"
        if self.user.user_role_id == 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_1_id, :message => "Mengomentari todos final project")
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_2_id, :message => "Mengomentari todos final project")
        elsif self.user.user_role_id == 2 and self.user_id == self.commentable.final_project.advisor_1_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.user_id, :message => "Mengomentari todos final project")
          #for advisor 2
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_2_id, :message => "Mengomentari todos final project")
        elsif self.user.user_role_id == 2 and self.user_id == self.commentable.final_project.advisor_2_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.user_id, :message => "Mengomentari todos final project")
          #for advisor 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_1_id, :message => "Mengomentari todos final project")
        end
      end
    end
end
