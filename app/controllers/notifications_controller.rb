class NotificationsController < ApplicationController
  def index
    @notification = Notification.count_notification_unread(current_user.id).count
    respond_to do |format|
      format.js
    end
  end

  def show
    @notification_unread_count = Notification.count_notification_unread(current_user.id).count
    @notification_all = Notification.notification_all(current_user.id).limit(5)
    notification = render_to_string(:partial => 'notifications/partials/notification_message', :locals => {:notifications_all => @notification_all, :notification_unread_count => @notification_unread_count}).to_json
    render :js => "$('#notification_message').html(#{notification});$('.timeago').timeago();$('#notification_number').html('');"
  end
end
