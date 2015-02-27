class DashboardsController < ApplicationController
  before_filter :authenticate_user!
  layout "application"
  
  def index
    @news = News.order('created_at desc').limit(5)
    if current_user.is_admin?
      @user_late = User.student.select{|f| f.students_status.is_working_final_project? and f.final_project.last_report_time}
    end
    if current_user.is_kaprodi?
      @user_late = User.student.where(:faculty_id => current_user.faculty_id).select{|f| f.students_status.is_working_final_project? and f.final_project.last_report_time}
    end
  end
end
