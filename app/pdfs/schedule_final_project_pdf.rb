class ScheduleFinalProjectPdf < Prawn::Document
  def initialize(examiner_schedule)
    super(top_margin: 70)
    @examiner_schedule = examiner_schedule
    examiner_schedule_title
    line_items
  end
  
  def examiner_schedule_title
    text "Daftar Penguji Sidang", size: 30, style: :bold
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end
  
  def line_item_rows
    [["Mahasiswa", "Pembimbing 1", "Pembimbing 1", "Penguji 1", "Penguji 2", "Penguji 3"]] +
      @examiner_schedule.map do |f|
        [f['mahasiswa']]+f['pembimbing'].map{|k| k}+f['penguji'].map{|k| k}
      end
  end
end

