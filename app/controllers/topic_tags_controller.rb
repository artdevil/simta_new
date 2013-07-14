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
    if params[:confirm] == "decline"
      @topic_tag = current_user.advisor_topic_tag.find(params[:id])
      if @topic_tag.update_column(:status,false)
        render :js => "$('#topic_tag_#{@topic_tag.id}').html('<td colspan=\"3\">#{content_tag(:div,'permintaan konfirmasi telah dibatalkan.', :class => 'alert alert-danger')}</td>')"
      end
    elsif params[:confirm] == "accept"
    
    end
  end
  
  def show
    @topic_tag = current_user.advisor_topic_tag.find(params[:id])
    if @topic_tag.status == nil
      @proposal = current_user.advisor_1_proposals.new(:title => @topic_tag.title_recommended, :description => @topic_tag.description_recommended, :topic_id => @topic_tag.topic.id)
    else
      redirect_to dashboards_path, :notice => "#{I18n.t('topic_tag.proposal.failed')}"
    end
  end
end
