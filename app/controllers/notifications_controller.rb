class NotificationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:old, :show]
  def index
    @notification = current_user ? Notification.count_notification_unread(current_user.id).count : 0
    respond_to do |format|
      format.js
    end
  end

  def show
    @notification_unread_count = Notification.count_notification_unread(current_user.id).count
    @notification_all = Notification.notification_all(current_user.id).limit(10)
    notification = render_to_string(:partial => 'notifications/partials/notification_message', :locals => {:notifications_all => @notification_all, :notification_unread_count => @notification_unread_count}).to_json
    render :js => "$('#notification_message').html(#{notification});$('.timeago').timeago();$('#notification_number').html('');"
  end
  
  def old
    @notifications = Notification.includes(:sender).includes(:notifiable).notification_all(current_user.id)
    expires_in 5.minutes, public: true
  end
end
