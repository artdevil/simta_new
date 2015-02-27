class AddExaminerTimeToAdvisorSchedule < ActiveRecord::Migration
  def change
    add_column :advisors_statuses, :examiner_time, :text
  end
end
