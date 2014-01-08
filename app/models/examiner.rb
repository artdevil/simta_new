class Examiner < ActiveRecord::Base
  belongs_to :final_project
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  
  delegate :proposal, :to => :final_project
  #penguji 1 (ketua sidang)
  belongs_to :examiner_1, :class_name => "User", :foreign_key => "examiner_1_id"
  #penguji 2 (sekretaris sidang)
  belongs_to :examiner_2, :class_name => "User", :foreign_key => "examiner_2_id"
  #penguji 3
  belongs_to :examiner_3, :class_name => "User", :foreign_key => "examiner_3_id"
  
  default_scope where(:accepted => nil)
  scope :not_accepted_status, where(:accepted => nil)
  validates_presence_of :final_project_id, :on => :create
  validate :unique_of_examiner
  
  attr_accessor :examiner_1_name, :examiner_2_name, :examiner_3_name, :pass, :revision_status
  attr_accessible :revision_status, :pass, :accepted, :examiner_1_name, :examiner_2_name, :examiner_3_name, :datetime, :examiner_1_id, :examiner_2_id, :examiner_3_id, :location, :note, :final_project_id, :finished, :revision, :revision_date
  validate :check_revision_date
  
  before_update :check_pass_status
  before_update :check_revision_status
  
  def check_revision_date
    if revision_date < Date.today
      errors.add(:revision_date, "Wrong Time")
    end if pass == "lulus dengan revisi"
  end
  
  def check_pass_status
    if pass.present?
      case pass
      when 'lulus'
        finished = true
        accepted = true
        final_project.update_attributes(:finished => true)
      when 'tidak lulus'
        finished = true
        accepted = false
        final_project.update_attributes(:progress => 0)
        final_project.user.students_status.update_column(:status, 3)
      when 'lulus dengan revisi'
        revision = true
        finished = true
        notifications.create(:sender_id => self.examiner_2_id, :recipient_id => self.final_project.user_id, :message => "Final Project anda dalam masa revisi yang ditentukan. Silahkan mengupload revisi tugas akhir")
        final_project.user.students_status.update_column(:status, 5)
      end
    end
  end
  
  def check_revision_status
    if revision_status.present?
      case revision_status
      when 'accept'
        accepted = true
        final_project.update_attributes(:finished => true)
      when 'decline'
        accepted = false
        final_project.update_attributes(:progress => 0)
        final_project.user.students_status.update_column(:status, 3)
      end
    end
  end
  
  def working_revision?
    accepted == nil and revision == true and finished == true
  end
  
  def passed?
    datetime < DateTime.now + 2.hours
  end
  
  protected
    def unique_of_examiner
      examiners = [self.examiner_1_id, self.examiner_2_id, self.examiner_3_id]
      unless examiners.uniq == examiners
        errors.add(:examiner_1_name, "Pemeriksa tidak boleh sama")
        errors.add(:examiner_2_name, "Pemeriksa tidak boleh sama")
        errors.add(:examiner_3_name, "Pemeriksa tidak boleh sama")
      end
    end
end
