class TodoProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_user_advisor, :only => ['issue','issue_todo', 'finished', 'new_todo','create_todo','edit_todo','update_todo']
  
  def index
    @proposal = current_user.proposal
    if @proposal.progress == 100 and !@proposal.finished?
      flash[:notice] = "#{I18n.t('proposal.completed')}"
    end
    if @proposal.group_token.present?
      @todo_proposals_open = @proposal.shared_open_todo_proposal
      @todo_proposals_close = @proposal.shared_close_todo_proposal
    else
      @todo_proposals_open = @proposal.todo_proposals.includes(:user).open_issue
      @todo_proposals_close = @proposal.todo_proposals.includes(:user).close_issue
    end
  end

  def show
    @todo_proposal = TodoProposal.find(params[:id])
  end
  
  def new
    @todo_proposal = current_user.todo_proposals.new(:proposal_id => current_user.proposal.id)
  end
  
  def create
    @todo_proposal = current_user.todo_proposals.new(params[:todo_proposal])
    if @todo_proposal.save
      redirect_to todo_proposal_path(@todo_proposal), :notice => "#{I18n.t('todo_proposals.create.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_proposals.create.failed')}"
      render 'new'
    end
  end
  
  def edit
    @todo_proposal = current_user.todo_proposals.find(params[:id])
  end
  
  def update
    @todo_proposal = current_user.todo_proposals.find(params[:id])
    if @todo_proposal.update_attributes(params[:todo_proposal])
      redirect_to todo_proposal_path(@todo_proposal), :notice => "#{I18n.t('todo_proposals.update.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_proposals.update.failed')}"
      render :edit
    end
  end
  
  def new_todo
    @todo_proposal = @proposal.todo_proposals.new
  end
  
  def create_todo
    @todo_proposal = @proposal.todo_proposals.new(params[:todo_proposal])
    @todo_proposal.user_id = current_user.id
    if @todo_proposal.save
      redirect_to "/todo_proposals/issue/#{@proposal.user.slug}/#{@todo_proposal.slug}", :notice => "#{I18n.t('todo_proposals.create.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_proposals.create.failed')}"
      render 'new_todo'
    end
  end
  
  def edit_todo
    @todo_proposal = @proposal.todo_proposals.find(params[:id])
  end
  
  def update_todo
    @todo_proposal = @proposal.todo_proposals.find(params[:id])
    if @todo_proposal.update_attributes(params[:todo_proposal])
      redirect_to "/todo_proposals/issue/#{@proposal.user.slug}/#{@todo_proposal.slug}", :notice => "#{I18n.t('todo_proposals.update.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_proposals.update.failed')}"
      render 'edit_todo'
    end
  end
  
  def issue
    if @proposal.group_token.present?
      @todo_proposals_open = @proposal.shared_open_todo_proposal
      @todo_proposals_close = @proposal.shared_close_todo_proposal
    else
      @todo_proposals_open = @proposal.todo_proposals.includes(:user).open_issue
      @todo_proposals_close = @proposal.todo_proposals.includes(:user).close_issue
    end
  end
  
  def issue_todo
    @todo_proposal = @proposal.todo_proposals.find(params[:id])
  end
  
  def open
    user = User.find(params[:user_id])
    @proposal = Proposal.where(:user_id => user.id).first
    if @proposal.group_token.present?
      @todo_proposals = @proposal.shared_open_todo_proposal
    else
      @todo_proposals = @proposal.todo_proposals.includes(:user).open_issue
    end
    if current_user.is_student?
      open = render_to_string(:partial => "todo_proposals/partials/open_issue", :locals => {:open_issue => @todo_proposals}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    elsif current_user.is_advisor? or current_user.is_admin? or current_user.is_kaprodi?
      open = render_to_string(:partial => "todo_proposals/issue/open_issue", :locals => {:open_issue => @todo_proposals}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    end
  end
  
  def close
    user = User.find(params[:user_id])
    @proposal = Proposal.where(:user_id => user.id).first
    if @proposal.group_token.present?
      @todo_proposals = @proposal.shared_close_todo_proposal
    else
      @todo_proposals = @proposal.todo_proposals.includes(:user).close_issue
    end
    if current_user.is_student?
      close = render_to_string(:partial => "todo_proposals/partials/close_issue", :locals => {:close_issue => @todo_proposals}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    elsif current_user.is_advisor? or current_user.is_admin? or current_user.is_kaprodi?
      close = render_to_string(:partial => "todo_proposals/issue/close_issue", :locals => {:close_issue => @todo_proposals}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    end
  end
  
  def finished
    @todo_proposal = @proposal.todo_proposals.find(params[:id])
    if @todo_proposal.update_column(:status, true)
      render :js => "$('#issue_open_#{@todo_proposal.id}').remove();$('#open_count').html('#{@proposal.todo_proposals.open_issue.size}');$('#close_count').html('#{@proposal.todo_proposals.close_issue.size}')"
    end
  end
  
  #before-validate
  
  def check_user_advisor
    user = User.find(params[:user_id])
    @proposal = Proposal.where(:user_id => user.id).first
    unless can? :access_todo_proposal, @proposal
      redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
    end
  end
end
