class SendSms
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :number, :message
  validates_presence_of :number, :message
  validates_format_of :number, :with => /0[0-9]{10,12}/
  
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def save
    if self.valid?
      IO.popen("gammu-smsd-inject -c ~/.smsdrc TEXT #{self.number} -text '#{self.message}'")
      return true
    else
      false
    end
  end
end