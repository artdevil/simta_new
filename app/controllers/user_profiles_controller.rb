class UserProfilesController < ApplicationController
  before_filter :authenticate_user!
  layout "application"
  def index
    
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    
  end
  
  def update
    if current_user.update_with_password(params[:user])
      flash[:success] = "Your Profile Has Been Updates"
      redirect_to user_profiles_path
    else
      flash[:error] = "Your Profile can't updates"
      render :action => 'edit'
    end
  end
  
  def search
    if current_user.is_student?
      @user = User.search_lecture(params[:term], current_user.id)
    elsif current_user.is_advisor?
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
