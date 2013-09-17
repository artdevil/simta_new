class FinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def update_progress
    @final_project = check_user(params[:id])
    if @final_project.update_attributes(params[:final_project])
      form = render_to_string(:partial => "todo_final_projects/partials/update_progress_form", :locals => {:final_project => @final_project}).to_json
      render :js => "$('#progress_bar').attr('data-percent','#{@final_project.progress}%');$('#progress_bar_count').css('width','#{@final_project.progress}%');$('#update_progress_form').html(#{form});"
    else
      form = render_to_string(:partial => "todo_final_projects/partials/update_progress_form", :locals => {:final_project => @final_project}).to_json
      render :js => "$('#update_progress_form').html(#{form})"
    end
  end
  
  def new_report
    final_project = check_user(params[:id])
    @final_project_report = final_project.report_final_projects.new
    modal = render_to_string(:partial => "todo_final_projects/issue/report_final_project_modal").to_json
    form = render_to_string(:partial => "todo_final_projects/issue/report_form", :locals => {:final_project_report => @final_project_report}).to_json
    render :js => "$('#report_final_project_modal_in').html(#{modal});$('#reportFinalProjectModal .modal-content').html(#{form});$('#reportFinalProjectModal').modal('show');"
  end
  
  def create_report
    final_project = check_user(params[:id])
    @final_project_report = final_project.report_final_projects.new(params[:report_final_project])
    if @final_project_report.save
      data = render_to_string(:partial => "todo_final_projects/partials/reports_data", :locals => {:report_data => @final_project_report}).to_json
      render :js => "$('#table_bug_report tbody').prepend(#{data});$('#reportFinalProjectModal').modal('hide');"
    else
      form = render_to_string(:partial => "todo_final_projects/issue/report_form", :locals => {:final_project_report => @final_project_report}).to_json
      render :js => "$('#reportFinalProjectModal .modal-content').html(#{form});"
    end
  end
  
  def finished
    final_project = check_user(params[:id])
    if final_project.update_attributes(:finished => true)
      redirect_to dashboards_path, :notice => "#{I18n.t('final_project.finished.success')}"
    else
      redirect_to "/todo_proposals/issue/#{final_project.user.slug}", :alert => "#{I18n.t('final_project.finished.failed')}"
    end
  end
  
  #check validation
  def check_user(final_project_id)
    final_project = FinalProject.find(final_project_id)
    unless final_project.user_id == current_user.id or final_project.advisor_1_id = current_user.id or final_project.advisor_2_id == current_user.id
      redirect_to dashboards_path, :alert => "You are not authorized"
    end
    return final_project
  end
end
