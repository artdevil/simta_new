class TopicTagsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user_in_controller, :only => [:show,:edit, :update]
  load_and_authorize_resource
  
  def new
  
  end
  
  def edit
    @topic_tag = @user_set.find(params[:id])
  end
  
  def create
    @topic_tag = current_user.topic_tags.new(params[:topic_tag])
    if @topic_tag.save
      redirect_to dashboards_path, :notice => "#{I18n.t('topic_tag.create.success')}"
    else
      @topic = Topic.find(@topic_tag.topic_id)
      render 'topics/show', :alert => "#{I18n.t('topic_tag.create.failed')}"
    end
  end
  
  def update
    if params[:confirm] == "decline"
      @topic_tag = current_user.advisor_topic_tag.find(params[:id])
      if @topic_tag.update_attributes(:status => false)
        render :js => "$('#topic_tag_#{@topic_tag.id}').html('<td colspan=\"3\">#{content_tag(:div,'permintaan konfirmasi telah dibatalkan.', :class => 'alert alert-danger')}</td>')"
      end
    else
      @topic_tag = @user_set.find(params[:id])
      if @topic_tag.update_attributes(params[:topic_tag])
        redirect_to topic_tag_path(@topic_tag), :notice => "#{I18n.t('topic_tag.update.success')}"
      else
        render :edit, :error => "#{I18n.t('topic_tag.update.failed')}"
      end
    end
  end
  
  def show
    @topic_tag = @user_set.find(params[:id])
    if @topic_tag.status == nil and current_user.user_role.name == 'lecture'
      @proposal = current_user.advisor_1_proposals.new(:title => @topic_tag.title_recommended, :description => @topic_tag.description_recommended, :topic_id => @topic_tag.topic.id, :user_id => @topic_tag.user_id)
    end
  end
  
  def set_user_in_controller
    if current_user.user_role_id == 1
      @user_set = current_user.topic_tags
    elsif current_user.user_role_id == 2
      @user_set = current_user.advisor_topic_tag
    end
  end
end
