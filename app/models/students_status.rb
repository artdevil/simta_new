class StudentsStatus < ActiveRecord::Base
  belongs_to :user
  attr_accessible :status, :user_id
  validate :check_user_status
  before_save :check_user_status
  
  def is_no_status?
    status == 0
  end
  
  def is_tag_topic?
    status == 1
  end
  
  def is_waiting_for_create_proposal?
    status == 0 or status == 1
  end
  
  def is_working_proposal?
    status == 2
  end
  
  def is_working_final_project?
    status == 3
  end
  
  def is_final_session?
    status == 4
  end
  
  def is_working_revision?
    status == 5
  end
  
  def is_finished?
    status == 6
  end
  
  def for_now
    case status
    when 0
      "no status"
    when 1
      "tag topik"
    when 2
      "proposal"
    when 3
      "final project"
    end
  end
  
  private
    def check_user_status
      unless self.user.is_student?
        errors.add(:user_id, "not authorized user")
      end
    end 
end
