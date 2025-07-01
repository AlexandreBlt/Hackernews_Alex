class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:upvote]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
    set_post
    @likes = @post.votes_for.size
    @comments = @post.comments
    @comment = Comment.new
  end

  def upvote
    unless current_user.voted_for?(@post)
        @post.liked_by(current_user)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "pages/post", locals: { post: @post })
          end
          format.html { redirect_to root_path}
        end
      else
        @post.unliked_by(current_user)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "pages/post", locals: { post: @post, alert: "Vous avez déjà voté." })
          end
          format.html { redirect_to root_path, alert: "Vous avez déjà voté." }
        end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
