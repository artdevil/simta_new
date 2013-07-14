class Proposal < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  attr_accessor :advisor_2_name
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :progress, :title, :topic_id, :user_id, :advisor_2_name
  
  validates_presence_of :advisor_1_id, :advisor_2_id, :title, :topic_id, :user_id, :advisor_2_name
  validate :check_user_advisor_2_input
  
  private
    def check_user_advisor_2_input
      @user = User.where(:name => self.advisor_2_name, :user_role_id => 2).first
      unless @user
        errors.add(:advisor_2_name, "dosen can be found")
      end
    end
end
