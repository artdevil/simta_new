class AdvisorsStatus < ActiveRecord::Base
  belongs_to :user
  attr_accessible :max_coordinator, :user_id
  validate :check_user_status
  
  private
    def check_user_status
      unless self.user.user_role_id == 2
        errors.add(:user_id, "not authorized user")
      end
    end 
end
