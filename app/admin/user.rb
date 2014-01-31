ActiveAdmin.register User do
  batch_action :destroy, false
  batch_action :send_sms do |selection|
    redirect_to send_sms_admin_users_path(:collection_selection => params[:collection_selection])
  end
  #action item
  
  action_item :only => :index do
    if params['scope'] == 'student'
      link_to "Import Student", import_student_admin_users_path
    end
  end
  
  action_item :only => :index do
    if params['scope'] == 'advisor'
      link_to "Import Schedule", import_schedule_admin_users_path
    end
  end
  
  action_item :only => :show do
    link_to "Send SMS", send_sms_admin_users_path(:contact_phone => user.phone)
  end
  
  scope :all
  
  scope :student do |user|
    user.where(:user_role_id => 1)
  end
  
  scope :advisor do |user|
    user.where(:user_role_id => 2)
  end
  
  scope :final_project do |user|
    user.final_project
  end
  
  index do
    selectable_column
    column :username
    if params['scope'].blank?
      column :user_role
    end
    if params['scope'] == 'student'
      column :students_status do |f|
        case f.students_status.for_now
        when 'proposal'
          link_to f.students_status.for_now, admin_proposal_path(f.proposal)
        else
          f.students_status.for_now
        end
      end
    end
    if params['scope'] == 'advisor'
      column :max_coordinator do |f|
        f.advisors_status.max_coordinator
      end 
      column :max_coordinator do |f|
        f.advisors_status.coordinator
      end
    end
    if params['scope'] == 'final_project'
      column :nim do |f|
        f.keyid
      end
      column :title do |f|
        f.final_project.title
      end
      column :advisor_1 do |f|
        f.final_project.advisor_1.username
      end
      column :advisor_2 do |f|
        f.final_project.advisor_2.present? ? f.final_project.advisor_2.username : f.final_project.advisor_2_name
      end
      column :last_guidance, :sortable => :created_at do |f|
        timeago_tag f.final_project.report_final_projects.last.created_at, :nojs => true, :limit => 20.days.ago
      end
    end
    default_actions
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :username
      f.input :keyid, :label => "NIM/NIP"
      f.input :user_role, :include_blank => false
      f.input :faculty, :include_blank => false
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  
  show do
    panel "User Detail" do
      attributes_table_for user do
        row("Profile Picture") {image_tag user.avatar.url}
        row("Username") { user.username }
        row("Status") {user.user_role.name}
        row("Faculty") {user.faculty.name}
        row("Telephone") {user.phone}
        row("Address") {user.address}
        if user.is_advisor?
          row("max coordinator") {user.advisors_status.coordinator}
          row("max coordinator") {user.advisors_status.max_coordinator}
        end
        if user.is_student?
          row("progress now") {status_tag user.students_status.for_now, 'complete'}
        end
      end
    end
  end
  
  sidebar "Advisor as proposal", :only => :show, :if => proc{ user.is_advisor? } do
    table_for Proposal.advisor_student(user) do |t|
      t.column("Name") { |proposal| link_to proposal.user.username, admin_proposal_path(proposal) }
      t.column("status") {|proposal| proposal.current_user_is_advisor_1?(user) ? "advisor 1" : "advisor 2"}
      t.column("Progress") {|proposal| status_tag "#{proposal.progress}%", proposal.complete? ? 'complete' : 'in_progress'}
    end
  end
  
  sidebar "Student Proposal Status", :only => :show, :if => proc{ user.is_student?  and user.students_status.is_working_proposal? } do
    attributes_table_for user.proposal do
      row("Title") { |proposal| link_to proposal.title, admin_proposal_path(proposal) }
      row("Advisor 1") { |proposal| proposal.advisor_1 }
      row("Advisor 2") { |proposal| proposal.advisor_2 }
      row("Progress") {|proposal| status_tag "#{proposal.progress}%", proposal.complete? ? 'complete' : 'in_progress'}
    end
  end
  
  
  #action for response
  
  collection_action :import_schedule, :method => :get do
    @import_schedule = ImportSchedule.new
  end
  
  collection_action :create_import_schedule, :method => :post do 
    @import_schedule = ImportSchedule.new(params[:import_schedule])
    if @import_schedule.save
      flash[:notice] = "Schedule Import has been finished"
      redirect_to admin_users_path
    else
      flash[:error] = "Schedule Import failure"
      render :import_schedule
    end
  end
  
  collection_action :import_student, :method => :get do
    @import_student = ImportStudent.new
  end
  
  #action for response
  
  collection_action :send_sms do
    contact = params[:contact_phone] || params[:collection_selection]
    @user = User.search_for_sms(contact).map(&:phone).reject(&:nil?)*","
    @send_sms = SendSms.new(:all_number => @user)
  end
  
  collection_action :send_sms_action, :method => :post do
    @send_sms = SendSms.new(params[:send_sms])
    if @send_sms.save_all
      flash[:notice] = "SMS has been sent"
      redirect_to admin_users_path
    else
      flash[:error] = "SMS can't sent"
      render :send_sms
    end
  end
  
  collection_action :create_import_student, :method => :post do 
    @import_student = ImportStudent.new(params[:import_student])
    if @import_student.save
      flash.now[:success] = "Student Import has been finished"
      redirect_to admin_users_path
    else
      flash.now[:error] = "Student Import failure"
      render :import_student
    end
  end
  
  member_action :search_only_advisor, :method => :get do
    @user = User.search_lecture(params[:term], params[:id])
    @user = @user.reject{|x| x.advisors_status.try(:coordinator) > x.advisors_status.try(:max_coordinator) }
  end
  
  controller do
    def scoped_collection
      if !params['scope'].blank? and params['scope'] == 'student'
        resource_class.includes(:user_role).includes(:students_status) 
      elsif !params['scope'].blank? and params['scope'] == 'advisor'
        resource_class.includes(:user_role).includes(:advisors_status) 
      else
        resource_class.includes(:user_role) 
      end
    end
  end
end
