class FinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_for_update, :only => [:update_progress,:finished, :edit, :update]
  before_filter :check_user_for_report, :only => [:new_report, :create_report, :show]
  
  def show
  
  end
  
  def edit
    
  end
  
  def update
    if @final_project.update_attributes(params[:final_project])
      redirect_to "/todo_final_projects/issue/#{@final_project.user.slug}", :notice => "#{I18n.t('final_project.update.success')}"
    else
      flash[:alert] = "#{I18n.t('final_project.update.failed')}"
      render :edit
    end
  end
  
  def update_progress
    if @final_project.update_attributes(params[:final_project])
      form = render_to_string(:partial => "todo_final_projects/partials/update_progress_form", :locals => {:final_project => @final_project, :error_report => ""}).to_json
      render :js => "$('#progress_bar').attr('data-percent','#{@final_project.progress}%');$('#progress_bar_count').css('width','#{@final_project.progress}%');$('#update_progress_form').html(#{form});"
    else
      if @final_project.errors.full_messages.first == "Pembimbing pertama belum memenuhi final project report (masih kurang dari 8)"
        @error_report = "Pembimbing pertama belum memenuhi final project report (masih kurang dari 8)"
      elsif @final_project.errors.full_messages.first == "Pembimbing kedua belum memenuhi final project report (masih kurang dari 8)"
        @error_report = "Pembimbing kedua belum memenuhi final project report (masih kurang dari 8)"
      end
      form = render_to_string(:partial => "todo_final_projects/partials/update_progress_form", :locals => {:final_project => @final_project, :error_report => @error_report}).to_json
      render :js => "$('#update_progress_form').html(#{form});"
    end
  end
  
  def new_report
    @final_project_report = @final_project.report_final_projects.new
    modal = render_to_string(:partial => "todo_final_projects/issue/report_final_project_modal").to_json
    form = render_to_string(:partial => "todo_final_projects/issue/report_form", :locals => {:final_project_report => @final_project_report}).to_json
    render :js => "$('#report_final_project_modal_in').html(#{modal});$('#reportFinalProjectModal .modal-content').html(#{form});$('#reportFinalProjectModal').modal('show');"
  end
  
  def create_report
    @final_project_report = @final_project.report_final_projects.new(params[:report_final_project])
    @final_project_report.user = current_user
    if @final_project_report.save
      data = render_to_string(:partial => "todo_final_projects/partials/reports_data", :locals => {:report_data => @final_project_report}).to_json
      render :js => "$('#table_bug_report_#{current_user.id} tbody').prepend(#{data});$('#reportFinalProjectModal').modal('hide');"
    else
      form = render_to_string(:partial => "todo_final_projects/issue/report_form", :locals => {:final_project_report => @final_project_report}).to_json
      render :js => "$('#reportFinalProjectModal .modal-content').html(#{form});"
    end
  end
  
  def finished
    if @final_project.update_attributes(:finished => true)
      redirect_to dashboards_path, :notice => "#{I18n.t('final_project.finished.success')}"
    else
      redirect_to "/todo_proposals/issue/#{final_project.user.slug}", :alert => "#{I18n.t('final_project.finished.failed')}"
    end
  end
  
  private
    #check validation
    def check_user_for_update
      @final_project = FinalProject.find(params[:id])
      unless @final_project.advisor_1 == current_user
        redirect_to dashboards_path, :alert => "You are not authorized"
      end
    end
  
    def check_user_for_report
      @final_project = FinalProject.find(params[:id])
      if @final_project.check_user_access(current_user.id)
        redirect_to dashboards_path, :alert => "You are not authorized"
      end
    end
end
