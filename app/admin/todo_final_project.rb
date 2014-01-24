ActiveAdmin.register TodoFinalProject do
  menu false
  
  show do
    panel "Todo Final Project Detail" do
      attributes_table_for todo_final_project do
        row("Final Project") {link_to todo_final_project.final_project.title, admin_final_project_path(todo_final_project.final_project)}
        row("Deskripsi") {raw todo_final_project.message}
      end
    end
    
    panel "Comment" do
      comments = todo_final_project.comments
      render :partial => 'admin/report_final_projects/comments', :locals => {:comments => comments}
    end
  end
end
