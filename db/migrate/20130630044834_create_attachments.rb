class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :attachmentable_id
      t.string :attachmentable_type
      t.string :file

      t.timestamps
    end
  end
end
