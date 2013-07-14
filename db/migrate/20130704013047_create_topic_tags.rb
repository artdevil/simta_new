class CreateTopicTags < ActiveRecord::Migration
  def change
    create_table :topic_tags do |t|
      t.integer :user_id
      t.integer :advisor_id
      t.integer :topic_id
      t.string :title_recommended
      t.text :description_recommended
      t.boolean :status
      t.timestamps
    end
  end
end
