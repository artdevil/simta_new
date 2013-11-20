class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def edit
    @comment = Comment.find(params[:id])
    comment = render_to_string(:partial => "todo_proposals/partials/edit_comment", :locals => {:comment => @comment }).to_json
    render :js => "$('#comment_form_input').html(#{comment});"
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      comment = render_to_string(:partial => "todo_proposals/partials/item_todo_comment_content", :locals => {:comment_status => @comment }).to_json
      render :js => "$('#comment_#{@comment.id}').html(#{comment});$('.timeago').timeago();$('#commentModal').modal('hide');"
    else
      comment = render_to_string(:partial => "todo_proposals/partials/edit_comment", :locals => {:comment => @comment }).to_json
      render :js => "$('#comment_form_input').html(#{comment});"
    end
  end
  
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
