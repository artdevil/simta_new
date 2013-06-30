class MessagesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @message = Message.new
    @message_inbox = current_user.received_messages
    @message_outbox = current_user.sent_messages
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = current_user
    if @message.save
      redirect_to messages_path, :notice => "#{I18n.t('message.notification.sent')}"
    else
      redirect_to messages_path, :notice => "#{I18n.t('message.notification.failed')}"
    end
  end

  def show
    @message = Message.read_message(params[:id], current_user)
    message = render_to_string(:partial => "messages/partials/message_inbox", :locals => {:message => @message }).to_json
    render :js => "$('#modal').html(#{message});$('#messageModal').modal('show');$('#message_#{@message.id}').removeClass('unread');"
  end

  def destroy
    @message = current_user.received_messages.find(params[:id])
    if @message
      message_id = @message.id
      if @message.mark_deleted(current_user)
        render :js => "$('#message_#{message_id}').remove();"
      end
    end
    
  end
  
  def reply
    reply = Message.find(params[:id])
    @message = Message.new(:recipient_name => reply.sender.username, :recipient_id => reply.sender_id, :subject => "Re : #{reply.subject}")
    message = render_to_string(:partial => "messages/partials/new_message", :locals => {:message => @message }).to_json
    render :js => "$('#messageModal').modal('hide');$('#new').html(#{message});$('#message_new_tab').click();"
  end
end
