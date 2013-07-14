class StudentsStatus < ActiveRecord::Base
  belongs_to :user
  attr_accessible :status, :user_id
  validate :check_user_status
  before_save :check_user_status
  
  private
    def check_user_status
      unless self.user.user_role_id == 1
        errors.add(:user_id, "not authorized user")
      end
    end 
end
