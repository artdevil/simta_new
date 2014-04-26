class AdvisorsSchedule < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :friday, :monday, :thursday, :tuesday, :wednesday
  validate :check_user_status
  
  def self.time
    ['06.30-08.30','08.30-10.30','10.30-12.30','12.30-14.30','14.30-16.30']
  end
  
  def update_empty
    self.monday = self.monday || '-'
    self.tuesday = self.tuesday || '-'
    self.wednesday = self.wednesday || '-'
    self.thursday = self.thursday || '-'
    self.friday = self.friday || '-'
    self.save
  end
  
  private
    def check_user_status
      unless self.user.is_advisor? or self.user.is_kaprodi?
        errors.add(:user_id, "not authorized user")
      end
    end 
end
