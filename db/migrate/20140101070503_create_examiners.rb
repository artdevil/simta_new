class CreateExaminers < ActiveRecord::Migration
  def change
    create_table :examiners do |t|
      t.datetime :datetime
      t.string :location
      t.text :note
      t.integer :final_project_id
      t.integer :examiner_1_id
      t.integer :examiner_2_id
      t.integer :examiner_3_id
      t.boolean :accepted
      t.timestamps
    end
  end
end
