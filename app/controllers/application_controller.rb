class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
  end
  
  def after_sign_in_path_for(resource)
    if current_user
      dashboards_path
    else current_admin_user
      admin_dashboard_path
    end
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  hide_action :current_user
  
  def authorize
    if current_user.is_advisor? 
      Rack::MiniProfiler.authorize_request
    end
  end
end
