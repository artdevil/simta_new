class AdvisorsStatus < ActiveRecord::Base
  acts_as_taggable_on :skills
  belongs_to :user
  attr_accessible :max_coordinator, :user_id, :skills
  validate :check_user_status
  
  def self.skill_all
    ['Jaringan', 'Transmisi', 'Pensinyalan', 'Mikro', 'Pemrograman']
  end
  
  private
    def check_user_status
      unless self.user.is_advisor? or self.user.is_kaprodi?
        errors.add(:user_id, "not authorized user")
      end
    end 
end
