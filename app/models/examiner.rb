class Examiner < ActiveRecord::Base
  belongs_to :final_project
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  delegate :user, :to => :final_project
  delegate :proposal, :to => :final_project
  #penguji 1 (ketua sidang)
  belongs_to :examiner_1, :class_name => "User", :foreign_key => "examiner_1_id"
  has_one :examiner_1_status, :through => :examiner_1, :source => :advisors_status
  #penguji 2 (sekretaris sidang)
  belongs_to :examiner_2, :class_name => "User", :foreign_key => "examiner_2_id"
  has_one :examiner_2_status, :through => :examiner_2, :source => :advisors_status
  #penguji 3
  belongs_to :examiner_3, :class_name => "User", :foreign_key => "examiner_3_id"
  has_one :examiner_3_status, :through => :examiner_3, :source => :advisors_status
  
  default_scope where(:accepted => nil)
  scope :not_accepted_status, where(:accepted => nil, :finished => true)
  scope :can_go_session, where(:can_session => true)
  validates_presence_of :final_project_id, :on => :create
  validate :unique_of_examiner, :on => :update, :if => Proc.new{ examiner_1_id or examiner_2_id or examiner_3_id }
  
  attr_accessor :examiner_1_name, :examiner_2_name, :examiner_3_name, :pass, :revision_status
  attr_accessible :revision_status, :pass, :accepted, :examiner_1_name, :examiner_2_name, :examiner_3_name, :datetime, :examiner_1_id, :examiner_2_id, :examiner_3_id, :location, :note, :final_project_id, :finished, :revision, :revision_date, :can_session
  validate :check_revision_date
  validate :check_book_final_project, :on => :update, :if => Proc.new{ can_session }
  validates :datetime, :location, :presence => true, :if => Proc.new{ can_session }
  
  before_update :check_pass_status
  before_update :check_revision_status
  
  def status
    if !can_session and !finished and !revision and !examiner_completed and accepted == nil
      "tunggu konfirmasi"
    elsif can_session and !finished and !revision and !examiner_completed and accepted == nil
      "cari dosen penguji"
    elsif can_session and !finished and !revision and examiner_completed and accepted == nil
      "siap sidang"
    elsif can_session and finished and revision and examiner_completed and accepted == nil
      "revisi"
    end
  end
  
  def examiner_completed
    if examiner_1.present? and examiner_2.present?
      true
    else
      false
    end
  end
  
  def check_revision_date
    if revision_date < Date.today
      errors.add(:revision_date, "Wrong Time")
    end if pass == "lulus dengan revisi"
  end
  
  def self.kaprodi(faculty)
    select{|f| f.final_project.user.faculty_id == faculty}
  end
  
  def check_pass_status
    if self.pass.present?
      case pass
      when 'lulus'
        self.finished = true
        self.accepted = true
        self.final_project.update_attributes(:finished => true)
      when 'tidak lulus'
        self.finished = true
        self.accepted = false
        self.final_project.update_attributes(:progress => 0)
        self.final_project.user.students_status.update_column(:status, 3)
      when 'lulus dengan revisi'
        self.revision = true
        self.finished = true
        self.notifications.create(:sender_id => self.examiner_2_id, :recipient_id => self.final_project.user_id, :message => "Final Project anda dalam masa revisi yang ditentukan. Silahkan mengupload revisi tugas akhir")
        self.final_project.user.students_status.update_column(:status, 5)
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
  
  def status_examiner
    if !can_session and finished.nil? and accepted.nil?
      "Periksa berkas sidang"
    end
  end
  
  def self.search_random_schedule
    AdvisorsStatus.update_all(:quota_examiner => 5)
    Examiner.can_go_session.map do |exam|
      {"mahasiswa" => exam.final_project.user.username, "pembimbing" => exam.search_advisor, "penguji" => exam.search_examiner_with_skill, "ruang" => exam.location, "tanggal" => exam.datetime.strftime('%d %b %Y, %H:%M')}
    end
  end
  
  def search_advisor
    [final_project.advisor_1.advisors_status.code_advisor, (final_project.advisor_2.present? ? final_project.advisor_2.advisors_status.code_advisor : final_project.advisor_2_name)]
  end
  
  def search_examiner_with_skill
    dont_include = [final_project.advisor_1_id, (final_project.advisor_2.present? ? final_project.advisor_2_id : 0)]
    first_level = User.search_examiner_with_skill(final_project.field, dont_include, self, 3)
    first_level.map{|f| f.advisors_status.decrement!(:quota_examiner) }
    if first_level.length == 3
      return first_level.collect{|f| f.advisors_status.code_advisor }
    else
      length_first_level = first_level.length
      dont_include + first_level.map(&:id)
      second_level = User.search_examiner_without_skill(dont_include, self, 3-length_first_level)
      second_level.map{|f| f.advisors_status.decrement!(:quota_examiner) }
      return first_level.collect{|f| f.advisors_status.code_advisor } + second_level.collect{|f| f.advisors_status.code_advisor }
    end
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
    
    def check_book_final_project
      unless final_project.document_final_project.present?
        errors.add(:base, "Buku tugas akhir belum di upload")
        self.can_session = false
      end
    end 
end
