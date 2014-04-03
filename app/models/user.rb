class User < ActiveRecord::Base
  has_private_messages
  extend FriendlyId
  friendly_id :username, use: :slugged
  
  #relation
  belongs_to :faculty
  belongs_to :user_role
  has_many :topics, :dependent => :destroy
  has_one :proposal, :dependent => :destroy
  has_one :final_project, :dependent => :destroy
  has_many :topic_tags, :dependent => :destroy
  has_many :news, :dependent => :destroy
  has_many :advisor_1_proposals, :class_name => "Proposal", :foreign_key => "advisor_1_id"
  accepts_nested_attributes_for :advisor_1_proposals, :allow_destroy => true
  has_many :advisor_2_proposals, :class_name => "Proposal", :foreign_key => "advisor_2_id"
  has_many :advisor_1_final_projects, :class_name => "FinalProject", :foreign_key => "advisor_1_id"
  accepts_nested_attributes_for :advisor_1_proposals, :allow_destroy => true
  has_many :advisor_2_final_projects, :class_name => "FinalProject", :foreign_key => "advisor_2_id"
  has_one :students_status, :dependent => :destroy
  accepts_nested_attributes_for :students_status, :allow_destroy => true
  has_one :advisors_status, :dependent => :destroy
  accepts_nested_attributes_for :advisors_status, :allow_destroy => true
  has_one :advisors_schedule, :dependent => :destroy
  accepts_nested_attributes_for :advisors_schedule, :allow_destroy => true
  has_many :advisor_topic_tag, :class_name => "TopicTag", :foreign_key => "advisor_id"
  has_many :todo_proposals, :dependent => :destroy
  has_many :todo_final_projects, :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :report_final_projects, :dependent => :destroy
  has_many :examiners, :finder_sql => proc{"SELECT * FROM Examiners where (examiner_1_id = #{id} or examiner_2_id = #{id} or examiner_3_id = #{id})"}, :dependent => :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :authentication_keys => [:keyid]

  attr_accessor :birthday
  # Setup accessible (or protected) attributes for your model
  attr_accessible :password,:birthday, :password_confirmation, :remember_me, :username, :avatar, :user_role_id, :keyid, :slug, :students_status_attributes, :advisor_1_proposals_attributes, :faculty_id,
  :phone, :address, :advisors_status_attributes
  # attr_accessible :title, :body
  
  
  #upload image
  mount_uploader :avatar, AvatarUploader
  
  #scope definition
  scope :lecture, where("user_role_id = 2 or user_role_id = 4")
  scope :student, where(:user_role_id => 1)
  scope :search_lecture, lambda{|user, current_user| where{(user_role_id == 2) & ((username =~ "%#{user}%") & (id != current_user)) | ((keyid =~ "%#{user}%") & (id != current_user)) }}
  scope :search_student, lambda{|user, current_user| where{(user_role_id == 1) & ((username =~ "%#{user}%") & (id != current_user)) | ((keyid =~ "%#{user}%") & (id != current_user)) }}
  scope :select_student, lambda{|user| where{(id == user) & (user_role_id == 1)}}
  scope :select_lecture, lambda{|user| where{(id == user) & (user_role_id == 2)}}
  scope :search_examiner, lambda{|user, users| where('(username like ? or keyid like ? ) and user_role_id = 2 and id not in (?)', "%#{user}%","%#{user}%", users)}
  scope :search_examiner_with_skill, lambda{|skill, users, day, size| joins(:advisors_status, :advisors_schedule).where("users.id not in (?) and advisors_statuses.skills like ? and advisors_schedules.#{day.datetime.strftime('%A').downcase} not like ? and advisors_statuses.quota_examiner > 0", users, "%#{skill}%", "%#{day.datetime.strftime('%H.%M')}-#{(day.datetime+2.hours).strftime('%H.%M')}%").sample(size)}
  scope :search_examiner_without_skill, lambda{|users, day, size| joins(:advisors_status,:advisors_schedule).where("users.id not in (?)  and advisors_schedules.#{day.datetime.strftime('%A').downcase} not like ? and advisors_statuses.quota_examiner > 0", users, "%#{day.datetime.strftime('%H.%M')}-#{(day.datetime+2.hours).strftime('%H.%M')}%").sample(size)}
  
  # active admin
  scope :final_project, joins(:students_status).where(:students_status => { :status => 3})
  
  # SMS
  scope :search_for_sms, lambda{|users| where("id IN (?)", users)}
  
  #validates
  validates_presence_of :username
  validates :keyid, :presence => true, :uniqueness => true
  #validate key id with different role
  validates :keyid, :format => {:with => /\A[0-9]{9}/, message: "invalid key id"}, :if => :is_student?
  validates :keyid, :format => {:with => /\A[0-9]{8}-[0-9]{1}/, message: "invalid key id"}, :unless => :is_student?
  validates :password, :confirmation => true, :presence => true,:on => :create, :if => :birtday_need?
  validates :birthday, :presence => true, :format => {:with => /\A[0-9]{2}-[0-9]{2}-[0-9]{4}/, message: "invalid birthday"}, :unless => :birtday_need?
  validates :faculty_id, :presence => true
  validates :address, :presence => true, :on => :update
  validates :phone, :presence => true, :on => :update
  validates_format_of :phone, :with => /0[0-9]{10,12}\z/, :allow_blank => true
  
  #callback
  before_create :set_password, :if => Proc.new{ self.password.blank? }
  after_create :build_students_status, :if => Proc.new{ self.user_role_id.blank? or self.is_student?}
  after_create :build_advisors_status, :if => Proc.new{ self.is_advisor? or self.is_kaprodi?}
  
  def build_students_status
    StudentsStatus.create(:user_id => self.id)
  end
  
  def build_advisors_status
    AdvisorsStatus.create(:user_id => self.id)
    AdvisorsSchedule.create(:user_id => self.id)
  end
  
  def is_student?
    user_role_id == 1
  end
  
  def is_advisor?
    user_role_id == 2
  end
  
  def is_admin?
    user_role_id == 3
  end
  
  def is_kaprodi?
    user_role_id == 4
  end
  
  def user_is_role
    if is_student?
      "Mahasiswa"
    elsif is_advisor?
      "Dosen"
    elsif is_admin?
      "Admin"
    elsif is_kaprodi?
      "Kaprodi"
    end
  end
  
  def admin_area?
    is_admin? or is_kaprodi?
  end
  
  def public_area?
    is_student? or is_advisor?
  end
  
  def is_profile_complete?
    user.valid?
  end
    
  protected
    
    def birtday_need?
      !self.birthday.present?
    end
    
    def set_password
      password_generate = Date.strptime(self.birthday, '%d-%m-%Y').strftime('%d%m%Y')
      self.password = password_generate
      self.password_confirmation = password_generate
    end
  
    def email_required?
      false
    end
  
    def self.included(base)
      base.extend ClassMethods
      assert_validations_api!(base)

      base.class_eval do
        validates_presence_of :email, :if => :email_required?
        validates_uniqueness_of :email, :allow_blank => true, :if => :email_changed?, :scope => [:account]
        validates_format_of :email, :with => email_regexp, :allow_blank => true, :if => :email_changed?
      
        validates_presence_of :password, :if => :password_required?
        validates_confirmation_of :password, :if => :password_required?
        validates_length_of :password, :within => password_length, :allow_blank => true
      end
    end
  
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(keyid) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
end
