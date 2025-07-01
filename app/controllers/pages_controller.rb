class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @posts = Post.all.sort_by { |post| -post.votes_for.size }
  end
end
