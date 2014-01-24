ActiveAdmin.register FinalProject do
  menu false
  batch_action :destroy, false
  batch_action :send_sms do |selection|
    redirect_to send_sms_admin_users_path(:collection_selection => params[:collection_selection])
  end
      
  index do
    selectable_column do
      f.user.id
    end
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
    column :last_guidance, :sortable => :created_at do |f|
      timeago_tag f.report_final_projects.last.created_at, :nojs => true, :limit => 20.days.ago
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
  
  show do
    panel "Final Project Detail" do
      attributes_table_for final_project do
        row("Title") {final_project.title}
        row("status") {final_project.finished? ? 'Selesai' : 'dalam pengerjaan'}
        row("Progress") {final_project.progress.to_s+ " %"}
        row("Mahasiswa") { link_to final_project.user.username, admin_user_path(final_project.user)}
        row("Pembimbing 1") {link_to final_project.advisor_1.username, admin_user_path(final_project.advisor_1.username)}
        row("Pembimbing 2") {final_project.advisor_2.present? ? (link_to final_project.advisor_2.username, admin_user_path(final_project.advisor_2.username)) : final_project.advisor_2_name}
        row("Deskripsi") {raw final_project.description}
        row("Dokumen Proposal") {link_to 'Proposal', admin_proposal_path(final_project.proposal)}
        if final_project.document_final_project.present?
          row("Buku TA") { link_to 'Buku', final_project.document_final_project.url}
        end
        if final_project.document_revision_final_project.present?
          row("Buku TA") { link_to 'Buku', final_project.document_revision_final_project.url}
        end
      end
    end
    
    panel "Report Final Project" do
      reports = final_project.report_final_projects
      render :partial => 'admin/final_projects/reports', :locals => {:reports => reports, :final_project => final_project}
    end
    
    panel "Activity" do
      activities_graph = PublicActivity::Activity.order("created_at desc").where(recipient_id: final_project.id, recipient_type: "FinalProject").group_by{|f| f.created_at.to_date}.map do |k,v|
        {
          :created_at => k.to_date,
          :count => v.size
        }
      end
      render :partial => 'admin/final_projects/activities', :locals => {:activities_graph => activities_graph}
    end
    
    panel "History" do
      activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: final_project.id, recipient_type: "FinalProject").page(params[:page]).per(10)
      render :partial => 'admin/final_projects/history', :locals => {:activities => activities, :final_project => final_project}
    end
  end
  
  member_action :report_final_project do
    @final_project = FinalProject.find(params[:id])
    @reports = @final_project.report_final_projects.new
    render 'admin/report_final_projects/new'
  end
  
  member_action :create_report_final_project, :method => :post do
    @final_project = FinalProject.find(params[:id])
    @reports = @final_project.report_final_projects.new(params[:report_final_project])
    if @reports.save
      flash[:notice] = "Report has been create"
      redirect_to admin_final_project_path(@final_project)
    else
      flash[:error] = "Report can't create"
      render 'admin/report_final_projects/new'
    end
  end
  
  member_action :get_history, :method => :get do
    final_project = FinalProject.find(params[:id])
    activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: final_project.id, recipient_type: "FinalProject").page(params[:page]).per(10)
    render :partial => 'admin/final_projects/get_history', :locals => {:activities => activities, :final_project => final_project}
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
