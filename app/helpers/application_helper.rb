module ApplicationHelper
  def notification_link notification
    if notification.notifiable.class.name == "TopicTag"
      "#{root_path}"
    elsif notification.notifiable.class.name == "Proposal"
      if current_user.is_student? and notification.notifiable.finished?
        "#{root_path}"
      elsif current_user.is_student? and !notification.notifiable.finished?
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
  
  def set_timing timing
    shift_now = timing.split(',').map do |f|
      case f
      when "06.30-08.30"
        "<span class='label'>shift_1</span>"
      when "08.30-10.30"
        "<span class='label label-success'>shift_2</span>"
      when "10.30-12.30"
        "<span class='label label-warning'>shift_3</span>"
      when "12.30-14.30"
        "<span class='label label-important'>shift_4</span>"
      when "14.30-16.30"
        "<span class='label label-info'>shift_5</span>"
      end
    end
    return shift_now.join(' ')
  end
  
end
