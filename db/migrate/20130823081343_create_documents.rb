class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.string :name
      t.string :file
      t.string :document_type

      t.timestamps
    end
  end
end
