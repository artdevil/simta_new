class ImportSchedule
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :file
  validates_presence_of :file  # 
  # validate :check_extension_file
  
  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def save
    if check_extension_file
      Rails.logger.info(imported_schedules)
      if imported_schedules.map(&:present?).all?
        true
      else
        imported_schedules.each_with_index do |schedule, index|
          unless schedule.present?
            errors.add :base, "Row #{index+3} Tidak bisa terbaca"
          end
        end
        false
      end
    else
      false
    end
  end
  
  def imported_schedules
    @imported_schedules ||= load_imported_schedules
  end

  def load_imported_schedules
    spreadsheet = open_spreadsheet
    Rails.logger.info('test')
    header = spreadsheet.row(2)
    (3..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row["nip"] = row["nip"]
      advisor = User.find_by_keyid(row["nip"])
      if advisor.present?
        advisor.advisors_schedule.update_attributes(:monday => row["monday"], :tuesday => row["tuesday"], :wednesday => row["wednesday"], :thursday => row["thursday"], :friday => row["friday"])
      end
      advisor
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else 
      errors.add :base, "Unknown file type: #{file.original_filename}"
    end
  end
  
  def check_extension_file
    extension_file = File.extname(file.original_filename)
    if ![".csv",".xls",".xlsx"].include?(extension_file)
      errors.add :file, "Unknown file type: #{file.original_filename}"
      false
    else
      true
    end
  end
  
end