class AdminSettingsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  
  def index
    @admin_setting = AdminSetting.first
  end
  
  def update
    @admin_setting = AdminSetting.find(params[:id])
    if @admin_setting.update_attributes(params[:admin_setting])
      flash[:success] = "Setting berhasil terupdate"
      redirect_to admin_settings_path
    else
      flash[:error] = "Setting gagal terupdate"
      render :index
    end
  end
end
