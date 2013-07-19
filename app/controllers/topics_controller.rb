class TopicsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @topics = Topic.includes(:user).page(params[:page]).per(5)
  end
  
  def new
    @topic = current_user.topics.new
  end
  
  def create
    @topic = current_user.topics.new(params[:topic])
    if @topic.save
      redirect_to topic_path(@topic), :notice => "#{I18n.t('topic.create.success')}"
    else
      flash[:alert] = "#{I18n.t('topic.create.failed')}"
      render 'new'
    end
  end
  
  def edit
    @topic = current_user.topics.find(params[:id])
  end
  
  def update
    @topic = current_user.topics.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to topic_path(@topic), :notice => "#{I18n.t('topic.update.success')}"
    else
      flash[:alert] = "#{I18n.t('topic.update.failed')}"
      render 'edit'
    end
  end

  def show
  end
end
