class FinalProject < ActiveRecord::Base
  attr_accessible :advisor_1_id, :advisor_2_id, :description, :finished, :progress, :proposal_id, :title, :user_id
end
