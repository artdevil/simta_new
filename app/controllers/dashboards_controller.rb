class DashboardsController < ApplicationController
  before_filter :authenticate_user!
  layout "application"
  
  def index
    @news = News.order('created_at desc').limit(5)
  end
end
