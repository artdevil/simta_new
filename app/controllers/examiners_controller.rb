class ExaminersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_autorization_to_read, :only => :show
  before_filter :user_autorization_to_update, :only => [:update, :revision_status]
  
  def show
    
  end
  
  def revision_status
    if @examiner.update_attributes(params[:examiner])
      redirect_to root_path
    end
  end
  
  def update
    if @examiner.update_attributes(params[:examiner])
      flash.now[:success] = "Sidang berhasil di update"
      respond_to do |format|
        format.js
      end
    else
      flash.now[:alert] = "Sidang gagal di update"
      respond_to do |format|
        format.js
      end
    end
  end
  
  def user_autorization_to_read
    @examiner = FinalProject.find(params[:id]).examiners.first
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}" unless can? :show, @examiner
  end
  
  def user_autorization_to_update
    @examiner = Examiner.find(params[:id])
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}" unless can? :update, @examiner
  end
end
