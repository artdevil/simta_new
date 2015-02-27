class AddGroupTokenToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :group_token, :string
    add_column :final_projects, :group_token, :string
  end
end
