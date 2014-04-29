class SendSms
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :number, :message, :all_number, :from_form
  
  validates :message, :presence => true
  validates :number, :presence => true, :unless => :is_from_form?
  validates :all_number, :presence => true, :if => :is_from_form?
  validates_format_of :number, :with => /0[0-9]{10,12}\z/, :unless => :is_from_form?
  
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def is_from_form?
    self.from_form
  end
  
  def save
    IO.popen("gammu-smsd-inject -c ~/.smsdrc TEXT #{self.number} -text '#{self.message}'")
  end
  
  def save_all
    if self.valid?
      if load_saving_sms.map(&:valid?).all?
        load_saving_sms.each(&:save)
        true
      else
        self.errors.add(:all_number, "nomor telephone ada yang salah, mohon di cek")
        false
      end
    else
      false
    end
  end
  
  def saving_sms
    @saving_sms ||= load_saving_sms
  end
  
  def load_saving_sms
    all_number.split(',').map do |f|
      sms = SendSms.new(:number => f, :message => message, :from_form => false)
      sms
    end
  end
  
  def self.send_to_all
    user_late = User.student.select{|f| f.students_status.is_working_final_project? and f.final_project.last_report_time}
    send_sms = SendSms.new
    send_sms.all_number = user_late.map(&:phone).join(',')
    send_sms.message = "Anda tidak melakukan bimbingan selama lebih dari 2 minggu. Silahkan hubungi dosen pembimbing anda - SIMTA -"
    send_sms.from_form = true
    send_sms.save_all
    send_sms.send_to_advisor(user_late)
  end
  
  def send_to_advisor(user_late)
    user_late.each do |f|
      advisor = f.final_project.advisor_1.phone
      if advisor.present?
        send_sms = SendSms.new
        send_sms.all_number = advisor
        send_sms.message = "Mahasiswa anda (#{f.username}/#{f.keyid}) tidak melakukan bimbingan selama lebih dari 2 minggu - SIMTA -"
        send_sms.from_form = true
        send_sms.save_all
      end
    end
  end
end