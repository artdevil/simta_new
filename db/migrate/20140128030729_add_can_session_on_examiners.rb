class AddCanSessionOnExaminers < ActiveRecord::Migration
  def change
    add_column :examiners, :can_session, :boolean, :default => false
  end
end
