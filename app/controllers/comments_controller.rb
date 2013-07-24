class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render "comments/created_failed" }
      end
    end
  end
end
