class PostsController < ApplicationController
  def index
    @recent_posts =
      Post.recent_posts_of(
        current_user.friends.pluck(:id) << current_user.id
      ).with_attached_images.includes(author: :avatar_attachment, comments: { author: :avatar_attachment })
  end

  def create
    post = current_user.posts.build(post_params)

    if post.save
      flash[:notice] = 'Your post has been created.'
    else
      flash[:danger] = 'Something went wrong, please try again.'
    end

    redirect_to root_path
  end

  def update
    post = current_user.posts.find(params[:id])

    if post.update(post_params_without_images) && post_params[:images]
      post.images.attach(post_params[:images])
    end

    redirect_to root_path anchor: "post-#{post.id}"
  end

  def destroy
    current_user.posts.find_by_id(params[:id])&.destroy
    redirect_to root_path, flash: { notice: "Post was deleted."}
  end

  private

    def post_params
      params.require(:post).permit(:content, images: [])
    end

    def post_params_without_images
      params.require(:post).permit(:content)
    end
end
