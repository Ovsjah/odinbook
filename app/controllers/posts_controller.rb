class PostsController < ApplicationController
  def index
    @recent_posts = Post.recent_posts_of(current_user.friends.pluck(:id) << current_user.id)
  end
end
