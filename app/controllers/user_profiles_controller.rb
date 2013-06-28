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
end
