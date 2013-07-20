class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      comment = render_to_string(:partial => "todo_proposals/partials/item_todo_comment", :locals => {:comment => @comment}).to_json
      form = render_to_string(:partial => "todo_proposals/partials/todo_form", :locals => {:todo_comment => Comment.new(:commentable_id => @comment.commentable_id, :commentable_type => @comment.commentable_type)}).to_json
      render :js => "$('.remove_nested_fields').click();$('#comments').append(#{comment});$('.timeago').timeago();"
    else
      render :nothing => :true
    end
  end
end
