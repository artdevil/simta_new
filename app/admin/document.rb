ActiveAdmin.register Document do
  form do |f|                         
    f.inputs "Admin Details" do
      f.input :name
      f.input :admin_user_id, :as => :hidden, :input_html => {:value => current_admin_user.id }
      f.input :file
      f.input :document_type, :as => :select, :collection => Document.document_type_file
    end                               
    f.actions                         
  end
end
