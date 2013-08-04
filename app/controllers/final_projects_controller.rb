class FinalProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
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
  
  def new_report_final_project
    
  end
  
  def create_report_final_project
    
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
