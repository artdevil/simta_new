class ArchivesController < ApplicationController
  def index
    @archives = Attachment.where(:user_id => current_user.id).group_by{ |t| t.created_at.beginning_of_month }
  end
end
