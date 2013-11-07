class User < ActiveRecord::Base
  has_private_messages
  extend FriendlyId
  friendly_id :username, use: :slugged
  
  #relation
  belongs_to :faculty
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

  attr_accessor :birthday
  # Setup accessible (or protected) attributes for your model
  attr_accessible :password,:birthday, :password_confirmation, :remember_me, :username, :avatar, :user_role_id, :keyid, :slug, :students_status_attributes, :advisor_1_proposals_attributes, :faculty_id
  # attr_accessible :title, :body
  
  
  #upload image
  mount_uploader :avatar, AvatarUploader
  
  #scope definition
  scope :search_lecture, lambda{|user, current_user| where{(user_role_id == 2) & ((username =~ "%#{user}%") & (id != current_user)) | ((keyid =~ "%#{user}%") & (id != current_user)) & 'user.' }}
  scope :search_student, lambda{|user, current_user| where{(user_role_id == 1) & ((username =~ "%#{user}%") & (id != current_user)) | ((keyid =~ "%#{user}%") & (id != current_user)) }}
  scope :select_student, lambda{|user| where{(id == user) & (user_role_id == 1)}}
  scope :select_lecture, lambda{|user| where{(id == user) & (user_role_id == 2)}}
  
  #validates
  validates_presence_of :username
  validates :keyid, :presence => true, :uniqueness => true
  #validate key id with different role
  validates :keyid, :format => {:with => /\A[0-9]{9}/, message: "invalid key id"}, :if => :is_student?
  validates :keyid, :format => {:with => /\A[0-9]{8}-[0-9]{1}/, message: "invalid key id"}, :unless => :is_student?
  
  validates :password, :confirmation => true, :presence => true,:on => :create, :if => :birtday_need?
  validates :birthday, :presence => true, :format => {:with => /\A[0-9]{2}-[0-9]{2}-[0-9]{4}/, message: "invalid birthday"}, :unless => :birtday_need?
  validates :faculty_id, :presence => true
  
  #callback
  before_create :set_password, :if => Proc.new{ self.password.blank? }
  after_create :build_students_status, :if => Proc.new{ self.user_role_id.blank? or self.user_role_id == 1}
  after_create :build_advisors_status, :if => Proc.new{ self.user_role_id == 2}
  
  def build_students_status
    StudentsStatus.create(:user_id => self.id)
  end
  
  def build_advisors_status
    AdvisorsStatus.create(:user_id => self.id)
  end
  
    
  protected
    
    def is_student?
      self.user_role_id == 1
    end
    
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
