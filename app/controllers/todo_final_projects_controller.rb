class TodoFinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @final_project = current_user.final_project
    if @final_project.progress == 100
      flash[:notice] = "#{I18n.t('final_project.completed')}"
    end
    @report_final_projects = @final_project.report_final_projects
    @todo_final_project_open = @final_project.todo_final_projects.includes(:user).open_issue
    @todo_final_project_close = @final_project.todo_final_projects.includes(:user).close_issue
  end
  
  def show
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def issue
    @final_project = check_user_advisor(params[:user_id])
    @report_final_projects = @final_project.report_final_projects
    @todo_final_project_open = @final_project.todo_final_projects.includes(:user).open_issue
    @todo_final_project_close = @final_project.todo_final_projects.includes(:user).close_issue
  end
  
  def issue_todo
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def new
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.new
  end
  
  def create
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.new(params[:todo_final_project])
    @todo_final_project.user_id = current_user.id
    if @todo_final_project.save
      redirect_to todo_final_project_path(@todo_final_project), :notice => "#{I18n.t('todo_final_projects.create.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_final_projects.create.failed')}"
      render :new
    end
  end
  
  def edit
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def update
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
    if @todo_final_project.update_attributes(params[:todo_final_project])
      redirect_to todo_final_project_path(@todo_final_project), :notice => "#{I18n.t('todo_final_projects.update.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_final_projects.update.failed')}"
      render :edit
    end
  end
  
  def new_todo
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.new
  end
  
  def create_todo
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.new(params[:todo_final_project])
    @todo_final_project.user_id = current_user.id
    if @todo_final_project.save
      redirect_to "/todo_final_projects/issue/#{@final_project.user.slug}/#{@todo_final_project.slug}", :notice => "#{I18n.t('todo_final_projects.create.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_final_projects.create.failed')}"
      render 'new_todo'
    end
  end
  
  def edit_todo
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def update_todo
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
    if @todo_final_project.update_attributes(params[:todo_final_project])
      redirect_to "/todo_final_projects/issue/#{@final_project.user.slug}/#{@todo_final_project.slug}", :notice => "#{I18n.t('todo_final_projects.update.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_final_projects.update.failed')}"
      render 'edit_todo'
    end
  end
  
  def open
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_projects = @final_project.todo_final_projects.includes(:user).open_issue
    if current_user.is_student?
      open = render_to_string(:partial => "todo_final_projects/partials/open_issue", :locals => {:open_issue => @todo_final_projects}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    elsif current_user.is_advisor?
      open = render_to_string(:partial => "todo_final_projects/issue/open_issue", :locals => {:open_issue => @todo_final_projects}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    end
  end
  
  def close
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_projects = @final_project.todo_final_projects.includes(:user).close_issue
    if current_user.is_student?
      close = render_to_string(:partial => "todo_final_projects/partials/close_issue", :locals => {:close_issue => @todo_final_projects}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    elsif current_user.is_advisor?
      close = render_to_string(:partial => "todo_final_projects/issue/close_issue", :locals => {:close_issue => @todo_final_projects}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    end
  end
  
  def finished
    @final_project = check_user_advisor(params[:user_id])
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
    if @todo_final_project.update_column(:status, true)
      render :js => "$('#issue_open_#{@todo_final_project.id}').remove();$('#open_count').html('#{@final_project.todo_final_projects.open_issue.size}');$('#close_count').html('#{@final_project.todo_final_projects.close_issue.size}')"
    end
  end
  
  #before-validate
  
  def check_user_advisor(user_id)
    user = User.find(user_id)
    final_project = FinalProject.where(:user_id => user.id).first
    unless final_project.user == current_user or final_project.advisor_1_id == current_user.id or final_project.advisor_2_id == current_user.id
      redirect_to dashboards_path, :alert => "You are not authorized to access this page"
    end
    return final_project
  end
end
