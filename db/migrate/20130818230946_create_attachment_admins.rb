class CreateAttachmentAdmins < ActiveRecord::Migration
  def change
    create_table :attachment_admins do |t|
      t.integer :attachment_adminable_id
      t.string :attachment_adminable_type
      t.string :file

      t.timestamps
    end
  end
end
