class TodoProposalsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @todo_proposals_open = current_user.todo_proposals.includes(:user).open_issue
    @todo_proposals_close = current_user.todo_proposals.close_issue
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
  
  def issue
    
  end
  
  def open
    @todo_proposals = current_user.todo_proposals.open_issue
  end
  
  def close
    @todo_proposals = current_user.todo_proposals.open_issue
  end
end
