class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment was successfully created.'
    else
      redirect_to post_path(@post), alert: 'Error creating comment.'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    redirect_to post_path(@post), notice: 'Comment was successfully deleted.'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_user!
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
    unless @comment.user == current_user
      redirect_to post_path(@post), alert: 'You are not
  authorized to perform this action.'
    end
  end
end
