ActiveAdmin.register User do
  config.batch_actions = false
  
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
    end
    f.actions
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
