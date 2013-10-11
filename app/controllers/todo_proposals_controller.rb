class TodoProposalsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_advisor, :only => ['issue','issue_todo', 'finished', 'new_todo','create_todo']
  load_and_authorize_resource
  
  def index
    @proposal = current_user.proposal
    if @proposal.progress == 100
      flash[:notice] = "#{I18n.t('proposal.completed')}"
    end
    @todo_proposals_open = @proposal.todo_proposals.includes(:user).open_issue
    @todo_proposals_close = @proposal.todo_proposals.includes(:user).close_issue
  end

  def show
    @todo_proposal = TodoProposal.find(params[:id])
  end
  
  def new
    @todo_proposal = current_user.todo_proposals.new(:proposal_id => current_user.proposal.id)
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
  
  def create
    @todo_proposal = current_user.todo_proposals.new(params[:todo_proposal])
    if @todo_proposal.save
      redirect_to todo_proposal_path(@todo_proposal), :notice => "#{I18n.t('todo_proposals.create.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_proposals.create.failed')}"
      render 'new'
    end
  end
  
  def issue
    @todo_proposals_open = @proposal.todo_proposals.includes(:user).includes(:proposal).open_issue
    @todo_proposals_close = @proposal.todo_proposals.includes(:user).includes(:proposal).close_issue
  end
  
  def issue_todo
    @todo_proposal = @proposal.todo_proposals.find(params[:id])
  end
  
  def open
    user = User.find(params[:user_id])
    @proposal = Proposal.where(:user_id => user.id).first
    @todo_proposals = @proposal.todo_proposals.includes(:user).open_issue
    if current_user.user_role_id == 1
      open = render_to_string(:partial => "todo_proposals/partials/open_issue", :locals => {:open_issue => @todo_proposals}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    elsif current_user.user_role_id == 2
      open = render_to_string(:partial => "todo_proposals/issue/open_issue", :locals => {:open_issue => @todo_proposals}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    end
  end
  
  def close
    user = User.find(params[:user_id])
    @proposal = Proposal.where(:user_id => user.id).first
    @todo_proposals = @proposal.todo_proposals.includes(:user).close_issue
    if current_user.user_role_id == 1
      close = render_to_string(:partial => "todo_proposals/partials/close_issue", :locals => {:close_issue => @todo_proposals}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    elsif current_user.user_role_id == 2
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
    unless @proposal.advisor_1_id == current_user.id or @proposal.advisor_2_id == current_user.id
      redirect_to dashboards_path, :alert => "You are not authorized to access this page"
    end
  end
end
