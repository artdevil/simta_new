class UserProfilesController < ApplicationController
  before_filter :authenticate_user!
  layout "application"
  def index
    
  end

  def show
    
  end

  def edit
    
  end
  
  def update
    if current_user.update_with_password(params[:user])
      redirect_to user_profiles_path
    else
      render :action => 'edit'
    end
  end
  
  def search
    if current_user.user_role_id == 1
      @user = User.search_lecture(params[:term], current_user.id)
    elsif current_user.user_role_id == 2
      @user = User.search_student(params[:term], current_user.id)
    end
  end
  
  def search_only_advisor
    @user = User.search_lecture(params[:term], current_user.id)
    @user = @user.reject{|x| x.advisors_status.try(:coordinator) > x.advisors_status.try(:max_coordinator) }
  end
  
  def search_only_student
    @user = User.search_student(params[:term], current_user.id)
    @user = @user.reject{|x| x.students_status.try(:status) != 0 }
  end
end
