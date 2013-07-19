class ProposalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def create
    @proposal = current_user.advisor_1_proposals.new(params[:proposal])
    if @proposal.save
      if !params[:topic_tag_id].blank?
        topic_tag = TopicTag.find(params[:topic_tag_id])
        topic_tag.update_status_true
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      else
        redirect_to dashboards_path, :notice => "#{I18n.t('proposal.create.success')}"
      end
    else
      if !params[:topic_tag_id].blank?
        @topic_tag = current_user.advisor_topic_tag.find(params[:topic_tag_id])
        flash[:alert] = "#{I18n.t('proposal.create.failed')}"
        render "topic_tags/show"
      else
        
      end
    end
  end
end
