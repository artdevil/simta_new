class TopicTagsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def new
  
  end
  
  def create
    @topic_tag = current_user.topic_tags.new(params[:topic_tag])
    if @topic_tag.save
      redirect_to dashboards_path, :notice => "#{I18n.t('topic_tag.create.success')}"
    else
      redirect_to topic_path(@topic_tag.topic_id), :alert => "#{I18n.t('topic_tag.create.failed')}"
    end
  end
  
  def update
  
  end
end
