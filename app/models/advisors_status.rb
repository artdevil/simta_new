class AdvisorsStatus < ActiveRecord::Base
  # acts_as_taggable_on :skills
  belongs_to :user
  attr_accessible :max_coordinator, :user_id, :skills, :code_advisor, :examiner_time
  validate :check_user_status, :on => :create
  
  def self.skill_all
    ['Jaringan', 'Transmisi', 'Pensinyalan', 'Mikro', 'Pemrograman']
  end
  
  private
    def check_user_status
      if self.user.presence
        unless self.user.is_advisor? or self.user.is_kaprodi?
          errors.add(:user_id, "not authorized user")
        end
      end
    end 
end
