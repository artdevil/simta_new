class AddSlugToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :slug, :string, :unique => true
  end
end
