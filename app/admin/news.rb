ActiveAdmin.register News do
  form do |f|                         
    f.inputs "Admin Details" do
      f.input :title
      f.input :admin_user_id, :as => :hidden, :input_html => {:value => current_admin_user.id }
      f.input :description, :as => :ckeditor, :input_html => {:ckeditor => {:customConfig => '/assets/ckeditor/myconfig.js'}}
      f.has_many :attachment_admins do |n|
        n.input :file
      end
    end                               
    f.actions                         
  end
end
