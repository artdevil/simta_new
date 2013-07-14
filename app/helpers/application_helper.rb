module ApplicationHelper
  def notification_link notification
    if notification.notifiable.class.name == "TopicTag"
      "#{root_path}"
    elsif notification.notifiable.class.name == "Message"
      "#{messages_path}"
    end
  end
end
