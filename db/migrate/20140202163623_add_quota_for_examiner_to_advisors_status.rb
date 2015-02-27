class AddQuotaForExaminerToAdvisorsStatus < ActiveRecord::Migration
  def change
    add_column :advisors_statuses, :quota_examiner, :integer
  end
end
