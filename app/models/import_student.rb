class ImportStudent
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
      if imported_students.map(&:valid?).all?
        imported_students.each(&:save!)
        true
      else
        imported_students.each_with_index do |student, index|
          student.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    else
      false
    end
  end
  
  def imported_students
    @imported_students ||= load_imported_students
  end

  def load_imported_students
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      row["keyid"] = row["keyid"].to_i.to_s
      student = User.new
      Rails.logger.info(row.to_hash.slice(*User.accessible_attributes))
      student.attributes = row.to_hash.slice(*User.accessible_attributes)
      student
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