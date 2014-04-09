class ExaminersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_autorization_to_read, :only => :show
  before_filter :user_autorization_to_update, :only => [:update, :revision_status]
  load_and_authorize_resource :except => :search
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Sidang", :examiners_path
  
  def index
    if current_user.is_admin?
      @examiners = Examiner.all
    elsif current_user.is_kaprodi?
      @examiners = Examiner.kaprodi(current_user.faculty_id)
    end
  end
  
  def edit
    add_breadcrumb "Edit Sidang"
  end
  
  def show
    
  end
  
  def revision_status
    if @examiner.update_attributes(params[:examiner])
      flash[:success] = "Tugas Akhir Telah Selesai"
      redirect_to root_path
    else
      flash[:success] = "Buku Revisi Tugas Akhir Belum Di Upload"
      redirect_to examiner_path(@examiner.final_project)
    end
  end
  
  def update
    if @examiner.update_attributes(params[:examiner])
      flash[:success] = "Sidang berhasil di update"
      respond_to do |format|
        format.html { redirect_to examiners_path }
        format.js
      end
    else
      flash[:alert] = "Sidang gagal di update"
      respond_to do |format|
        format.html {render :edit}
        format.js
      end
    end
  end
  
  def search
    final_project = FinalProject.find(params[:id])
    users = [final_project.advisor_1_id, final_project.advisor_2_id]
    @user = User.search_examiner(params[:term], users)
  end
  
  def schedule
    if params[:examiner].blank?
      if !Examiner.all.map{|f| !f.status.present? or f.status == "cari dosen penguji"}.all?
        redirect_to examiners_path, :alert => "Mohon diperiksa kesiapan status mahasiswa"
      else
        @examiner_schedule = Examiner.search_random_schedule
      end
    else
      @examiner_schedule = params[:examiner]
      respond_to do |format|
        format.html
        format.pdf do
          pdf = ScheduleFinalProjectPdf.new(@examiner_schedule)
          send_data pdf.render
        end
      end
    end
  end
  
  def user_autorization_to_read
    @examiner = FinalProject.find(params[:id]).examiners.first
    if (!(can? :show, @examiner) and (current_user.is_student? || current_user.is_advisor?))
      redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}"
    elsif (!(can? :show, @examiner) and (current_user.is_kaprodi? || current_user.is_admin?))
      redirect_to examiners_path, :alert => "Sidang belum siap"
    end
  end
  
  def user_autorization_to_update
    @examiner = Examiner.find(params[:id])
    redirect_to dashboards_path, :alert => "#{I18n.t('cancan.unauthorized')}" unless can? :update, @examiner
  end
end
