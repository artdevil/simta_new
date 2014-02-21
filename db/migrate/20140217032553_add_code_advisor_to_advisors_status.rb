class AddCodeAdvisorToAdvisorsStatus < ActiveRecord::Migration
  def change
    add_column :advisors_statuses, :code_advisor, :string
  end
end
