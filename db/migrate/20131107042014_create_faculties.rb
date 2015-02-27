class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.timestamps
    end
    ["S1-Teknik Elektro dan komunikasi","S1 Pindahan-Teknik Elektro dan komunikasi", "D3-Teknik Elektro dan komunikasi", "S1-Sistem Komputer"].each do |f|
      Faculty.create!(:name => f)
    end
  end
end
