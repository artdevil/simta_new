class AddFinishedToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :finished, :boolean, :null => false, :default => false
  end
end
