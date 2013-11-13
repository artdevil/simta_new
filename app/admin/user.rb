ActiveAdmin.register User do
  config.batch_actions = false
  #action item
  
  action_item :only => :index do
    link_to "Import Student", import_student_admin_users_path
  end
  
  scope :all
  
  scope :student do |user|
    user.where(:user_role_id => 1)
  end
  
  scope :advisor do |user|
    user.where(:user_role_id => 2)
  end
  
  index do
    column :username
    column :user_role
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
  
  sidebar "Student Proposal Status", :only => :show, :if => proc{ user.is_student? } do
    attributes_table_for user.proposal do
      row("Title") { |proposal| link_to proposal.title, admin_proposal_path(proposal) }
      row("Advisor 1") { |proposal| proposal.advisor_1 }
      row("Advisor 2") { |proposal| proposal.advisor_2 }
      row("Progress") {|proposal| status_tag "#{proposal.progress}%", proposal.complete? ? 'complete' : 'in_progress'}
    end
  end
  
  
  #action for response
  
  collection_action :import_student, :method => :get do
    @import_student = ImportStudent.new
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
