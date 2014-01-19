ActiveAdmin.register AdminSetting do
  actions :all, :except => [:destroy, :create, :new]
  
  form do |f|                         
    f.inputs "Admin Settings" do       
      f.input :guidance_time_minimal, :as => :select, :collection => AdminSetting.setting_time_minimal, :include_blank => false
    end                               
    f.actions                         
  end
  
  show do
    panel "Admin Setting Detail" do
      attributes_table_for admin_setting do
        row("Guidance Time Minimal") {admin_setting.guidance_time_minimal.to_s+ " Hari"}
      end
    end
  end
  
  controller do
    def index
      redirect_to edit_admin_admin_setting_path(1)
    end
  end
end
