class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :slug
      t.timestamps
    end
  end
end
