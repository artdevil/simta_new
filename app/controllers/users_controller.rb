class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "User", :news_index_path
  
  def advisors
    add_breadcrumb "Data Dosen"
    if current_user.is_admin?
      @users = User.lecture
    elsif current_user.is_kaprodi?
      @users = User.lecture.where(:faculty_id => current_user.faculty_id)
    end
  end
  
  def add_advisor
    add_breadcrumb "Tambah Dosen"
    @user = User.new
    @user.build_advisors_status
  end
  
  def create_advisor
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User telah ditambah"
      redirect_to advisors_users_path
    else
      flash[:error] = "User tidak berhasil ditambah"
      render :add_advisor
    end
  end
  
  def edit
    add_breadcrumb 'Edit User'
  end
  
  def update
    if @user.update_without_password(params[:user])
      flash[:success] = "User telah terupdate"
      if @user.is_student?
        redirect_to students_users_path
      elsif @user.is_advisor? or @user.is_kaprodi?
        redirect_to advisors_users_path
      end
    else
      add_breadcrumb 'Edit User'
      flash[:success] = "User gagal terupdate"
      render :edit
    end
  end
  
  def students
    add_breadcrumb "Data Mahasiswa"
    if current_user.is_admin?
      @users = User.student
    elsif current_user.is_kaprodi?
      @users = User.student.where(:faculty_id => current_user.faculty_id)
    end
  end
  
  def import_students
    add_breadcrumb "Import Mahasiswa"
    if params[:import_student].present?
      @import_student = ImportStudent.new(params[:import_student])
      if @import_student.save
        flash[:success] = "Student Import has been finished"
        redirect_to students_users_path
      else
        flash[:error] = "Student Import failure"
      end
    else
      @import_student = ImportStudent.new
    end
  end
  
  def import_advisors_schedule
    add_breadcrumb "Jadwal Dosen"
    @advisors_schedule = AdvisorsSchedule.all
    if params[:import_schedule].present?
      @import_schedule = ImportSchedule.new(params[:import_schedule])
      if @import_schedule.save
        flash[:notice] = "Schedule Import has been finished"
        redirect_to import_advisors_schedule_users_path, :method => :post
      else
        flash[:error] = "Schedule Import failure"
      end
    else
      @import_schedule = ImportSchedule.new
    end
  end
  
  def send_sms
    if params[:send_sms].present?
      @send_sms = SendSms.new(params[:send_sms])
      if @send_sms.save_all
        flash[:notice] = "SMS has been sent"
        redirect_to students_users_path
      else
        flash[:error] = "SMS can't sent"
      end
    else
      contact = params[:contact_phone] || params[:collection_selection]
      @user = User.search_for_sms(contact).map(&:phone).reject(&:nil?)*","
      @send_sms = SendSms.new(:all_number => @user)
    end
  end
end
