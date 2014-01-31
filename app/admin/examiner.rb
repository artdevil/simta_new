ActiveAdmin.register Examiner do
  menu false
  index do
    column :name do |f|
      f.final_project.user.name
    end
    column :nim do |f|
      f.final_project.user.keyid
    end
    column :final_project_title do |f|
      f.final_project.title
    end
    column :date_and_time do |f|
      f.datetime
    end
    column :examiner_1 do |f|
      f.examiner_1.username if f.examiner_1
    end
    column :examiner_2 do |f|
      f.examiner_2.username if f.examiner_2
    end
    column :examiner_3 do |f|
      f.examiner_3.username if f.examiner_3
    end
    default_actions
  end
  
  member_action :accept_for_session, :method => :put do
    examiner = Examiner.find(params[:id])
    if examiner.update_column(:can_session, true)
      redirect_to admin_examiners_path
    end
  end
  
  member_action :search, :method => :get do
    final_project = FinalProject.find(params[:id])
    users = [final_project.advisor_1_id, final_project.advisor_2_id]
    @user = User.search_examiner(params[:term], users)
  end
  
  form do |f|
    if f.object.can_session
      f.inputs "#{f.object.final_project.title}" do
        f.input :examiner_1_name, :as => :string, :input_html => {:class => "user_find_ajax", :data => {'autocomplete-source' => search_admin_examiner_path(f.object.final_project), :input => 'examiner_examiner_1_id'}}
        f.input :examiner_1_id, :as => :hidden
        f.input :examiner_2_name, :as => :string, :input_html => {:class => "user_find_ajax", :data => {'autocomplete-source' => search_admin_examiner_path(f.object.final_project), :input => 'examiner_examiner_2_id'}}
        f.input :examiner_2_id, :as => :hidden
        f.input :examiner_3_name, :as => :string, :input_html => {:class => "user_find_ajax", :data => {'autocomplete-source' => search_admin_examiner_path(f.object.final_project), :input => 'examiner_examiner_3_id'}}
        f.input :examiner_3_id, :as => :hidden
        f.input :datetime, :as => :string, :input_html => {:class => "datetimepicker"}
        f.input :location
        f.input :note
      end
      f.actions
    else
      "silahkan mengklik #{link_to 'di sini', accept_for_session_admin_examiner_path(f.object)} jika mahasiswa sudah siap"
    end
  end
  
  controller do
    def edit
      @page_title = "Awesome Title"
    end
  end
end
