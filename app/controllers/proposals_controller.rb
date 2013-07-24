class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def create
    @proposal = current_user.advisor_1_proposals.new(params[:proposal])
    if @proposal.save
      if !params[:topic_tag_id].blank?
        topic_tag = TopicTag.find(params[:topic_tag_id])
        topic_tag.update_status_true
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      else
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      end
    else
      if !params[:topic_tag_id].blank?
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
    @proposal = Proposal.find(params[:id])
    if @proposal.update_progress(params[:proposal])
      
    else
    
    end
  end
  
  def update_progress
    @proposal = Proposal.find(params[:id])
    if @proposal.update_attributes(params[:proposal])
      form = render_to_string(:partial => "todo_proposals/partials/update_progress_form", :locals => {:proposal => @proposal}).to_json
      render :js => "$('#progress_bar').attr('data-percent','#{@proposal.progress}%');$('#progress_bar_count').css('width','#{@proposal.progress}%');$('#update_progress_form').html(#{form});"
    else
      form = render_to_string(:partial => "todo_proposals/partials/update_progress_form", :locals => {:proposal => @proposal}).to_json
      render :js => "$('#update_progress_form').html(#{form})"
    end
  end
end
