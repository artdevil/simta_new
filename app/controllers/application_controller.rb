class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
  end
  
  def after_sign_in_path_for(resource)
    dashboards_path
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
