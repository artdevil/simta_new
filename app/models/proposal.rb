class Proposal < ActiveRecord::Base
  #relation
  belongs_to :user
  belongs_to :topic, :counter_cache => true
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :progress, :title, :topic_id, :user_id
end
