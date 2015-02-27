class TodoFinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_filter :check_user_advisor, :only => [:issue, :issue_todo, :new_todo, :create_todo, :edit_todo, :update_todo, :finished]
  
  def index
    @final_project = current_user.final_project
    if @final_project.status_now == "Masa Daftar Sidang"
      flash[:notice] = "#{I18n.t('final_project.completed')}"
    elsif @final_project.status_now == "Masa Sidang"
      flash[:notice] = "Anda memasuki masa sidang. Silahkan berkoordinasi dengan admin Fakultas"
    end
    @report_final_projects = @final_project.report_final_projects
    if @final_project.group_token.present?
      @todo_final_project_open = @final_project.shared_open_todo_final_project
      @todo_final_project_close = @final_project.shared_close_todo_final_project
    else
      @todo_final_project_open = @final_project.todo_final_projects.includes(:user).open_issue
      @todo_final_project_close = @final_project.todo_final_projects.includes(:user).close_issue
    end
  end
  
  def show
    @final_project = current_user.final_project
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def issue
    @report_final_projects = @final_project.report_final_projects
    if @final_project.group_token.present?
      @todo_final_project_open = @final_project.shared_open_todo_final_project
      @todo_final_project_close = @final_project.shared_close_todo_final_project
    else
      @todo_final_project_open = @final_project.todo_final_projects.includes(:user).open_issue
      @todo_final_project_close = @final_project.todo_final_projects.includes(:user).close_issue
    end
  end
  
  def issue_todo
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
    @todo_final_project = @final_project.todo_final_projects.new
  end
  
  def create_todo
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
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
  end
  
  def update_todo
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
    if @todo_final_project.update_attributes(params[:todo_final_project])
      redirect_to "/todo_final_projects/issue/#{@final_project.user.slug}/#{@todo_final_project.slug}", :notice => "#{I18n.t('todo_final_projects.update.success')}"
    else
      flash[:alert] = "#{I18n.t('todo_final_projects.update.failed')}"
      render 'edit_todo'
    end
  end
  
  def open
    user = User.find(params[:user_id])
    @final_project = FinalProject.where(:user_id => user.id).first
    if @final_project.group_token.present?
      @todo_final_projects = @final_project.shared_open_todo_final_project
    else
      @todo_final_projects = @final_project.todo_final_projects.includes(:user).open_issue
    end
    if current_user.is_student?
      open = render_to_string(:partial => "todo_final_projects/partials/open_issue", :locals => {:open_issue => @todo_final_projects}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    elsif current_user.is_advisor? or current_user.is_admin? or current_user.is_kaprodi?
      open = render_to_string(:partial => "todo_final_projects/issue/open_issue", :locals => {:open_issue => @todo_final_projects}).to_json
      render :js => "$('#open').html(#{open});$('.timeago').timeago();"
    end
  end
  
  def close
    user = User.find(params[:user_id])
    @final_project = FinalProject.where(:user_id => user.id).first
    if @final_project.group_token.present?
      @todo_final_projects = @final_project.shared_close_todo_final_project
    else
      @todo_final_projects = @final_project.todo_final_projects.includes(:user).close_issue
    end
    if current_user.is_student?
      close = render_to_string(:partial => "todo_final_projects/partials/close_issue", :locals => {:close_issue => @todo_final_projects}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    elsif current_user.is_advisor? or current_user.is_admin? or current_user.is_kaprodi?
      close = render_to_string(:partial => "todo_final_projects/issue/close_issue", :locals => {:close_issue => @todo_final_projects}).to_json
      render :js => "$('#close').html(#{close});$('.timeago').timeago();"
    end
  end
  
  def finished
    @todo_final_project = @final_project.todo_final_projects.find(params[:id])
    if @todo_final_project.update_column(:status, true)
      @todo_final_project.create_activity key: 'todo_final_project.close', :owner => current_user, :recipient => @todo_final_project.final_project
      render :js => "$('#issue_open_#{@todo_final_project.id}').remove();$('#open_count').html('#{@final_project.todo_final_projects.open_issue.size}');$('#close_count').html('#{@final_project.todo_final_projects.close_issue.size}')"
    end
  end
  
  #before-validate
  
  def check_user_advisor
    user = User.find(params[:user_id])
    @final_project = FinalProject.where(:user_id => user.id).first
    if @final_project.present?
      unless can? :access_todo_final_project, @final_project
        redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
      end
    else
      redirect_to dashboards_path, :alert => "User can't find or not on final project status"
    end
  end
end
