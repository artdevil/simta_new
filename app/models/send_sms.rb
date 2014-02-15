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
end