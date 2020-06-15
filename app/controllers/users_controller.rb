class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, flash: { notice: "Your profile is up to date."}
    else
      flash.now[:danger] = "Sorry, but something went wrong, please try again."
      render :edit
    end
  end

  def friends
    redirect_to root_path, flash: { notice: "You have no friends." } if current_user.friends.empty?
  end

  def seek
    to_seek = params[:search]
    @user =
      if to_seek.match? Devise.email_regexp
        User.case_insensitive_find :email, to_seek
      else
        User.case_insensitive_find :username, to_seek
      end

    if @user
      render :show
    else
      redirect_to root_path, flash: {danger: "Sorry, but the user doesn't exist."}
    end
  end

  def unfriend
    user = current_user.unfriend(params[:id]).first if User.exists?(params[:id])
    redirect_to friends_path, flash: { notice: "<b>#{user.username}</b> was successfully unfriended.".html_safe }
  end

  def like
    like = current_user.like(params[:post_id])
    render json: { likes_counter: like.post.likes.count, status: 200 }
  end

  def dislike
    dislike = current_user.dislike(params[:post_id])
    render json: { likes_counter: dislike.post.likes.count, status: 200 }
  end

  private

    def user_params
      params.require(:user).permit(:avatar, :email, :username)
    end
end
