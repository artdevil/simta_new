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
      row["monday"] = split_timing(row["monday"])
      row["tuesday"] = split_timing(row["tuesday"])
      row["wednesday"] = split_timing(row["wednesday"])
      row["thursday"] = split_timing(row["thursday"])
      row["friday"] = split_timing(row["friday"])
      advisor = User.find_by_keyid(row["nip"])
      if advisor.present?
        advisor.advisors_schedule.update_attributes(:monday => row["monday"], :tuesday => row["tuesday"], :wednesday => row["wednesday"], :thursday => row["thursday"], :friday => row["friday"])
      end
      advisor
    end
  end
  
  def split_timing(timing)
    timing = timing.try(:split,',').try(:map) do |f|
      case f
      when '1'
        '06.30-08.30'
      when '2'
        '08.30-10.30'
      when '3'
        '10.30-12.30'
      when '4'
        '12.30-14.30'
      when '5'
        '14.30-16.30'
      end
    end
    timing.try(:join,',')
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