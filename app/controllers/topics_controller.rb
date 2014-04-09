class TopicsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @topic_tag = Topic.tag_counts.in_groups_of(6)
    if params[:search_key].present?
      @topics = Topic.search_title(params[:search_key]).includes(:user).page(params[:page]).per(5)
    elsif params[:keyword].present?
      @topics = Topic.tagged_with(params[:keyword]).includes(:user).page(params[:page]).per(5)
    else
      @topics = Topic.includes(:user).page(params[:page]).per(5)
    end
  end
  
  def new
    @topic = current_user.topics.new
    @topic.proposals.build(:advisor_1_id => current_user.id)
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
    @topic.proposals.build(:advisor_1_id => current_user.id)
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
    @topic = Topic.find(params[:id])
    @topic_tag = current_user.topic_tags.new(:topic_id => @topic.id)
  end
end
