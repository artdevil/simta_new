class AdvisorsStatus < ActiveRecord::Base
  belongs_to :user
  attr_accessible :max_coordinator, :user_id
  validate :check_user_status
  
  private
    def check_user_status
      unless self.user.is_advisor?
        errors.add(:user_id, "not authorized user")
      end
    end 
end
