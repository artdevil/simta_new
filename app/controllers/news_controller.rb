class NewsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @news = News.includes(:admin_user).page(params[:page]).per(5)
  end

  def show
    @news = News.find(params[:id])
  end
end
