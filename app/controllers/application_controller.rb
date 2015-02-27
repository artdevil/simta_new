class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  protect_from_forgery
  skip_before_filter :verify_authenticity_token
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
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
