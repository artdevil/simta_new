ActiveAdmin.register FinalProject do
  index do
    column :student do |f|
      f.user.username
    end
    column :advisor_1 do |f|
      f.advisor_1.username
    end
    column :advisor_2 do |f|
      f.advisor_2.present? ? f.advisor_2.username : f.advisor_2_name
    end
    column :title do |f|
      f.title
    end
    column :progress do |f|
      "#{f.progress}%"
    end
    default_actions
  end
  
  form do |f|
    f.inputs "#{f.object.title}" do
      f.input :title
      f.input :advisor_2_name, :as => :string, :input_html => {:class => "user_find_ajax", :data => {'autocomplete-source' => search_admin_examiner_path(f.object), :input => 'final_project_advisor_2_id'}}
      f.input :advisor_2_id, :as => :hidden
      f.input :description, :as => :ckeditor, :input_html => {:ckeditor => {:customConfig => '/assets/ckeditor/myconfig.js'}}
      f.input :progress
    end
    f.actions
  end
  
  controller do

        def destroy
          final_project = FinalProject.find(params[:id])
          if final_project.proposal.destroy
            flash[:notice] = "Final Project berhasil dihapus"
            redirect_to admin_final_projects_path
          end
        end
      end
end
