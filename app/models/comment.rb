class Comment < ActiveRecord::Base
  # public activity
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked recipient: ->(controller, model) { model.commentable.final_project if model.commentable.class.name == "TodoFinalProject" }
  
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
  
  def shared_comments
    if self.commentable_type == "TodoProposal"
      Proposal.where('id != ? and group_token = ? ',self.commentable.proposal.id, self.commentable.proposal.group_token)
    elsif self.commentable_type == "TodoFinalProject"
      FinalProject.where('id != ? and group_token = ? ',self.commentable.final_project.id, self.commentable.final_project.group_token)
    end
  end
  
  def is_proposal?
    self.commentable.todo_final_project.present?
  end
  
  def self.is_final_project?
    self.commentable.todo_final_project.present?
  end
  
  private
    def set_notification
      if self.commentable_type == "TodoProposal"
        if self.user.is_student?
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_1_id, :message => "Mengomentari todos proposal")
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_2_id, :message => "Mengomentari todos proposal")
        elsif self.user.is_advisor? and self.commentable_type == "TodoProposal" and self.user_id == self.commentable.proposal.advisor_1_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.user_id, :message => "Mengomentari todos proposal")
          #for advisor 2
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_2_id, :message => "Mengomentari todos proposal")
        elsif self.user.is_advisor? and self.commentable_type == "TodoProposal" and self.user_id == self.commentable.proposal.advisor_2_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.user_id, :message => "Mengomentari todos proposal")
          #for advisor 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.proposal.advisor_1_id, :message => "Mengomentari todos proposal")
        end
        
        # for comment group
        if self.commentable.proposal.group_token.present?
          shared_comments.each do |proposal|
            self.notifications.create(:sender_id => self.user_id, :recipient_id => proposal.user_id, :message => "Mengomentari todos proposal")
          end
        end
      elsif self.commentable_type == "TodoFinalProject"
        if self.user.is_student?
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_1_id, :message => "Mengomentari todos final project")
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_2_id, :message => "Mengomentari todos final project")
        elsif self.user.is_advisor? and self.user_id == self.commentable.final_project.advisor_1_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.user_id, :message => "Mengomentari todos final project")
          #for advisor 2
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_2_id, :message => "Mengomentari todos final project")
        elsif self.user.is_advisor? and self.user_id == self.commentable.final_project.advisor_2_id
          #for student
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.user_id, :message => "Mengomentari todos final project")
          #for advisor 1
          self.notifications.create(:sender_id => self.user_id, :recipient_id => self.commentable.final_project.advisor_1_id, :message => "Mengomentari todos final project")
        end
        
        # for comment group
        if self.commentable.final_project.group_token.present?
          shared_comments.each do |final_project|
            self.notifications.create(:sender_id => self.user_id, :recipient_id => final_project.user_id, :message => "Mengomentari todos final project")
          end
        end
      end
    end
end
