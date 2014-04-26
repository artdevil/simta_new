class FinalProject < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  # public activity
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user || model.advisor_1}
  tracked recipient: ->(controller, model) { model }
  
  #relation
  belongs_to :user
  belongs_to :proposal, :dependent => :destroy
  belongs_to :advisor_1, :class_name => "User", :foreign_key => "advisor_1_id"
  belongs_to :advisor_2, :class_name => "User", :foreign_key => "advisor_2_id"
  has_many :notifications, :as => :notifiable, :dependent => :destroy
  has_many :todo_final_projects, :dependent => :destroy
  has_many :report_final_projects, :dependent => :destroy
  has_many :examiners, :dependent => :destroy
  
  attr_accessible :advisor_1_id, :advisor_2_id, :advisor_2_name, :description, :finished, :progress, :proposal_id, :title, :user_id, :document_final_project, :document_revision_final_project, :field, :group_token
  
  #upload image
  mount_uploader :document_final_project, DocumentFinalProjectUploader
  mount_uploader :document_revision_final_project, DocumentRevisionFinalProjectUploader
  
  #validation
  validate :check_user_status, :on => :create
  validates_presence_of :advisor_1_id, :description, :proposal_id, :title, :user_id, :field
  validate :cek_advisor_2_quota, :on => :update, :if => Proc.new{ self.advisor_2_name_changed? }
  validate :check_advisor_report, :on => :update, :if => Proc.new{ self.progress == 100 }
  validates_numericality_of :progress, :only_integer =>true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "invalid number"
  
  #callback
  after_update :update_user_status_to_finished, :if => Proc.new{ self.finished }
  after_update :set_notification_100, :if => Proc.new{ self.progress == 100 and !self.finished and !self.examiners.present?}
  before_update :check_change_advisor_2
  
  scope :advisor_student, lambda{|f| where("finished = false and (advisor_1_id = ? or advisor_2_id = ? )",f.id,f.id)}
  scope :in_progress, where("progress < ? and finished = ? ", 100, false)
  
  def check_user_access(user_id)
    if self.user_id != user_id and self.advisor_1_id != user_id and self.advisor_2_id != user_id
      return true
    else
      return false
    end
  end
  
  def is_advisor_1?(user_id)
    self.advisor_1 == user_id
  end
  
  def collection_advisor
    [self.advisor_1, (self.advisor_2 unless self.advisor_2_id.nil?)]
  end
  
  def self.kaprodi(faculty)
    in_progress.select{|f| f.user.faculty_id == faculty}
  end
  
  def status_now
    if progress < 100
      "Masa Tugas Akhir"
    elsif progress == 100 and !document_final_project.present?
      "Masa Daftar Sidang"
    elsif progress == 100 and document_final_project.present?
      "Masa Sidang"
    elsif progress == 100 and document_final_project.present? and examiners.present? and examiners.first.revision?
      "Masa Revisi"
    end
  end
  
  def last_report_time
    out_of_bond = self.report_final_projects.where("created_at <= ? ", DateTime.now - 2.week).last
    out_of_month = self.created_at <  DateTime.now - 1.month unless out_of_bond.present?
    all_of_data = self.report_final_projects.where("created_at >= ? ",DateTime.now - 2.week).present? if out_of_bond.present?
    if (out_of_bond.present? and !all_of_data.present?) or out_of_month.present?
      true
    else
      false
    end
  end
  
  private
    def cek_advisor_2_quota
      if self.advisor_2_id.present?
        advisor_2_status = User.select_lecture(self.advisor_2_id).first.try(:advisors_status)
        if advisor_2_status.present?
          if advisor_2_status.coordinator >= advisor_2_status.max_coordinator
            errors.add(:advisor_2_name, "Advisor quota is full")
          end
        else
          errors.add(:advisor_2_name, "can't find advisor 2")
        end
      end
    end
  
    def check_change_advisor_2
      if self.advisor_2_name_changed?
        self.proposal.update_column(:advisor_2_name, self.advisor_2_name)
        if self.advisor_2_id_changed?
          self.proposal.update_column(:advisor_2_id, self.advisor_2_id)
          increase_advisor_2
          decrease_advisor_2
        end
      end
    end
    
    def increase_advisor_2
      unless self.advisor_2_id.blank?
        self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_2.advisors_status.coordinator + 1)
      end
    end
    
    def decrease_advisor_2
      final_project = FinalProject.find(self)
      unless final_project.advisor_2_id.blank?
        final_project.advisor_2.advisors_status.update_column(:coordinator, final_project.advisor_2.advisors_status.coordinator - 1)
      end
    end
    
    def check_advisor_report
      if self.report_final_projects.advisor_progress(self.proposal.advisor_1_id).count < 8
        errors.add(:base, "Pembimbing pertama belum memenuhi final project report (masih kurang dari 8)")
      elsif self.proposal.advisor_2_id.present? and self.report_final_projects.advisor_progress(self.proposal.advisor_2_id).count < 8 
        errors.add(:base, "Pembimbing kedua belum memenuhi final project report (masih kurang dari 8)")
      end
    end
  
    def check_user_status
      if !self.user.students_status.is_working_proposal? and !self.user.proposal.present? and !self.user.proposal.finished? 
        errors.add(:base, "user can't create final project")
      end
    end
    
    def set_notification_100
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Final Project anda telah selesai. Silahkan mengupload buku dan mengajukan diri untuk sidang TA")
      notification.save
      self.user.students_status.update_column(:status, 4)
      self.examiners.create
    end
    
    def update_user_status_to_finished
      notification = self.notifications.new(:sender_id => self.advisor_1_id, :recipient_id => self.user_id, :message => "Selamat! Final Project anda telah selesai")
      notification.save
      self.user.students_status.update_column(:status, 6)
      update_advisor_decrease
    end
    
    def update_advisor_decrease
      self.advisor_1.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator - 1)
      if self.advisor_2.present?
        self.advisor_2.advisors_status.update_column(:coordinator, self.advisor_1.advisors_status.coordinator - 1)
      end
    end
end
