class FinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Proposals", :final_projects_path
  
  def index
    if current_user.is_admin?
      @final_projects = FinalProject.in_progress
    elsif current_user.is_kaprodi?
      @final_projects = FinalProject.kaprodi(current_user.faculty_id)
    end
  end
  
  def show
  
  end
  
  # def edit
#     
#   end
#   
#   def update
#     if @final_project.update_attributes(params[:final_project])
#       redirect_to "/todo_final_projects/issue/#{@final_project.user.slug}", :notice => "#{I18n.t('final_project.update.success')}"
#     else
#       flash[:alert] = "#{I18n.t('final_project.update.failed')}"
#       render :edit
#     end
#   end
  
  def update_document
    if @final_project.update_attributes(params[:final_project])
      form = render_to_string(:partial => "todo_final_projects/partials/upload_document_final_project_form", :locals => {:final_project => @final_project}).to_json
      render :js => "$('#document_final_project').html(#{form});"
    else
      form = render_to_string(:partial => "todo_final_projects/partials/upload_document_final_project_form", :locals => {:final_project => @final_project}).to_json
      render :js => "$('#document_final_project').html(#{form});"
    end
  end

  def show_history
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: @final_project.id, recipient_type: "FinalProject").page(params[:page]).per(20)
    @activities_graph = PublicActivity::Activity.order("created_at desc").where(recipient_id: @final_project.id, recipient_type: "FinalProject").group_by{|f| f.created_at.to_date}.map do |k,v|
      {
        :created_at => k.to_date,
        :count => v.size
      }
    end
  end
  
  def activities
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: @final_project.id, recipient_type: "FinalProject").page(params[:page]).per(20)
  end
  
  def update_progress
    if @final_project.update_attributes(params[:final_project])
      if @final_project.progress == 100
        @final_project.create_activity key: 'final_project.has_completed', :owner => current_user, :recipient => @final_project
      end
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
    @final_project_report.user = current_user if params[:report_final_project][:user_id].blank?
    if @final_project_report.save
      data = render_to_string(:partial => "todo_final_projects/partials/reports_data", :locals => {:report_data => @final_project_report}).to_json
      render :js => "$('#table_bug_report_#{@final_project_report.user_id} tbody').prepend(#{data});$('#reportFinalProjectModal').modal('hide');"
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
  
  # def destroy
  #   if @final_project.destroy
  #     redirect_to dashboards_path, :notice => "#{I18n.t('final_project.delete.success')}"
  #   end
  # end
end
