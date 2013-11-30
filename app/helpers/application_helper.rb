module ApplicationHelper
  def notification_link notification
    if notification.notifiable.class.name == "TopicTag"
      "#{root_path}"
    elsif notification.notifiable.class.name == "Proposal"
      if current_user.is_student?
        "#{todo_proposals_path}"
      elsif current_user.is_advisor?
        "/todo_proposals/issue/#{notification.notifiable.user.slug}"
      end
    elsif notification.notifiable.class.name == "Message"
      "#{messages_path}"
    elsif notification.notifiable.class.name == "Comment"
      comment = notification.notifiable
      if comment.commentable.class.name == "TodoProposal"
        if current_user.is_student?
          "#{todo_proposal_path(comment.commentable.slug)}"
        elsif current_user.is_advisor?
          "/todo_proposals/issue/#{comment.commentable.proposal.user.slug}/#{comment.commentable.slug}"
        end
      elsif comment.commentable.class.name == "TodoFinalProject"
        if current_user.is_student?
          "#{todo_final_project_path(comment.commentable.slug)}"
        elsif current_user.is_advisor?
          "/todo_final_projects/issue/#{comment.commentable.final_project.user.slug}/#{comment.commentable.slug}"
        end
      end
    elsif notification.notifiable.class.name == "TodoProposal"
      if current_user.is_student?
        "#{todo_proposal_path(notification.notifiable.slug)}"
      elsif current_user.is_advisor?
        "/todo_proposals/issue/#{notification.notifiable.proposal.user.slug}/#{notification.notifiable.slug}"
      end
    end
  end
end
