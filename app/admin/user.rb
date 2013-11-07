ActiveAdmin.register User do
  config.batch_actions = false
  #action item
  
  action_item do
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
    column :students_status do |f|
      f.students_status.status
    end if params['scope'] == 'student'
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
