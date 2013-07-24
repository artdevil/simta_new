module ApplicationHelper
  def notification_link notification
    if notification.notifiable.class.name == "TopicTag"
      "#{root_path}"
    elsif notification.notifiable.class.name == "Proposal"
      "#{todo_proposals_path}"
    elsif notification.notifiable.class.name == "Message"
      "#{messages_path}"
    elsif notification.notifiable.class.name == "Comment"
      if current_user.user_role_id == 1
        "#{todo_proposal_path(notification.notifiable.commentable.slug)}"
      elsif current_user.user_role_id == 2
        "/todo_proposals/issue/#{notification.notifiable.commentable.proposal.user.slug}/#{notification.notifiable.commentable.slug}"
      end
    elsif notification.notifiable.class.name == "TodoProposal"
      if current_user.user_role_id == 1
        "#{todo_proposal_path(notification.notifiable.slug)}"
      elsif current_user.user_role_id == 2
        "/todo_proposals/issue/#{notification.notifiable.proposal.user.slug}/#{notification.notifiable.slug}"
      end
    end
  end
end
