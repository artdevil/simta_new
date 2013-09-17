class User < ActiveRecord::Base
  has_private_messages
  extend FriendlyId
  friendly_id :username, use: :slugged
  
  #relation
  belongs_to :user_role
  has_many :topics, :dependent => :destroy
  has_one :proposal
  has_one :final_project
  has_many :topic_tags, :dependent => :destroy
  has_many :advisor_1_proposals, :class_name => "Proposal", :foreign_key => "advisor_1_id"
  accepts_nested_attributes_for :advisor_1_proposals, :allow_destroy => true
  has_many :advisor_2_proposals, :class_name => "Proposal", :foreign_key => "advisor_2_id"
  has_many :advisor_1_final_projects, :class_name => "FinalProject", :foreign_key => "advisor_1_id"
  accepts_nested_attributes_for :advisor_1_proposals, :allow_destroy => true
  has_many :advisor_2_final_projects, :class_name => "FinalProject", :foreign_key => "advisor_2_id"
  has_one :students_status, :dependent => :destroy
  has_one :advisors_status, :dependent => :destroy
  has_many :advisor_topic_tag, :class_name => "TopicTag", :foreign_key => "advisor_id"
  accepts_nested_attributes_for :students_status
  has_many :todo_proposals
  has_many :todo_final_projects
  has_many :attachments
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :authentication_keys => [:keyid]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me, :username, :avatar, :user_role_id, :keyid, :slug, :students_status_attributes, :advisor_1_proposals_attributes
  # attr_accessible :title, :body
  
  #upload image
  mount_uploader :avatar, AvatarUploader
  
  #scope definition
  scope :search_lecture, lambda{|user| where{(user_role_id == 2) & (username =~ "%#{user}%") | (keyid =~ "%#{user}%")}.limit(5)}
  scope :search_student, lambda{|user| where{(user_role_id == 1) & (username =~ "%#{user}%") | (keyid =~ "%#{user}%")}.limit(5)}
  
  #validating before save
  before_create :set_password, :if => Proc.new{ self.password.blank? }
  after_create :build_students_status, :if => Proc.new{ self.user_role_id.blank? or self.user_role_id == 1}
  after_create :build_advisors_status, :if => Proc.new{ self.user_role_id == 2}
  
  def set_password
    self.password = "Passw0rd"
  end
  
  def build_students_status
    student_status = StudentsStatus.new(:user_id => self.id)
    student_status.save
  end
  
  def build_advisors_status
    advisor_status = AdvisorsStatus.new(:user_id => self.id)
    advisor_status.save
  end
  
    
  protected
  
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
