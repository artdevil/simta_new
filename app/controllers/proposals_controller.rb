class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_user, :only => ['edit','update', 'update_document', 'update_progress','finished']
  
  def create
    @proposal = current_user.advisor_1_proposals.new(params[:proposal])
    if @proposal.save
      if params[:topic_tag_id].present?
        topic_tag = TopicTag.find(params[:topic_tag_id])
        topic_tag.update_status_true
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      else
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      end
    else
      if params[:topic_tag_id].present?
        @topic_tag = current_user.advisor_topic_tag.find(params[:topic_tag_id])
        flash[:alert] = "#{I18n.t('proposal.create.failed')}"
        render "topic_tags/show"
      else
        
      end
    end
  end
  
  def edit
   
  end
  
  def update
    if @proposal.update_attributes(params[:proposal])
      redirect_to todo_proposals_path, :notice => "#{I18n.t('proposal.update.success')}"
    else
      flash[:alert] = "#{I18n.t('proposal.update.failed')}"
      render 'edit'
    end
  end
  
  def update_document
    if @proposal.update_attributes(params[:proposal])
      form = render_to_string(:partial => "todo_proposals/partials/upload_file_form", :locals => {:proposal_form => @proposal}).to_json
      render :js => "$('#upload_file_proposal').html(#{form});"
    else
      form = render_to_string(:partial => "todo_proposals/partials/upload_file_form", :locals => {:proposal_form => @proposal}).to_json
      render :js => "$('#upload_file_proposal').html(#{form});"
    end
  end
  
  def update_progress
    if @proposal.update_attributes(params[:proposal])
      form = render_to_string(:partial => "todo_proposals/partials/update_progress_form", :locals => {:proposal => @proposal}).to_json
      render :js => "$('#progress_bar').attr('data-percent','#{@proposal.progress}%');$('#progress_bar_count').css('width','#{@proposal.progress}%');$('#update_progress_form').html(#{form});"
    else
      form = render_to_string(:partial => "todo_proposals/partials/update_progress_form", :locals => {:proposal => @proposal}).to_json
      render :js => "$('#update_progress_form').html(#{form})"
    end
  end
  
  def finished
    if !@proposal.exam.blank? and !@proposal.events.blank? and !@proposal.proposal.blank? and @proposal.update_attributes(:finished => true)
      redirect_to dashboards_path, :notice => "#{I18n.t('proposal.finished.success')}"
    else
      redirect_to "/todo_proposals/issue/#{@proposal.user.slug}", :alert => "#{I18n.t('proposal.finished.failed')}"
    end
  end
  
  #check validation
  def check_user
    @proposal = Proposal.find(params[:id])
    unless @proposal.user_id == current_user.id or @proposal.advisor_1_id = current_user.id or @proposal.advisor_2_id == current_user.id
      redirect_to dashboards_path, :alert => "You are not authorized"
    end
  end
end
