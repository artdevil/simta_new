class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
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
  
  def show
    @proposal = Proposal.find(params[:id])
  end
  
  def update
    if @proposal.update_attributes(params[:proposal])
      redirect_to params[:redirect_link], :notice => "#{I18n.t('proposal.update.success')}"
    else
      flash.now[:alert] = "#{I18n.t('proposal.update.failed')}"
      render 'edit'
    end
  end
  
  def update_document
    if @proposal.update_attributes(params[:proposal])
      form = render_to_string(:partial => "todo_proposals/partials/upload_file_form", :locals => {:proposal => @proposal}).to_json
      render :js => "$('#upload_file_proposal').html(#{form});"
    else
      form = render_to_string(:partial => "todo_proposals/partials/upload_file_form", :locals => {:proposal => @proposal}).to_json
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
    if @proposal.update_attributes(:finished => true)
      redirect_to dashboards_path, :notice => "#{I18n.t('proposal.finished.success')}"
    else
      @todo_proposals_open = @proposal.todo_proposals.includes(:user).includes(:proposal).open_issue
      @todo_proposals_close = @proposal.todo_proposals.includes(:user).includes(:proposal).close_issue
      @proposal.finished = false
      flash[:alert] = "#{I18n.t('proposal.finished.failed')}"
      render "/todo_proposals/issue"
    end
  end
  
  def destroy
    @proposal = Proposal.find(params[:id])
    if @proposal.destroy
      redirect_to dashboards_path, :notice => "#{I18n.t('proposal.delete.success')}"
    end
  end
end
