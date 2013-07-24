class AddDocumentToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :exam, :string
    add_column :proposals, :events, :string
    add_column :proposals, :proposal, :string
  end
end
