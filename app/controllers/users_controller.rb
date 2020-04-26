class UsersController < ApplicationController
  def seek
    to_seek = params[:search]
    @user =
      if to_seek.match? URI::MailTo::EMAIL_REGEXP
        User.find_by_email to_seek
      else
        User.find_by_username to_seek.parameterize(separator: '_')
      end

    if @user
      render :found
    else
      redirect_to root_path, flash: {danger: "Sorry, but the user doesn't exist."}
    end
  end

  def unfriend
    user = current_user.unfriend(params[:id]).first if User.exists?(params[:id])
    redirect_to friends_path, flash: { notice: "<b>#{user.username}</b> was successfully unfriended.".html_safe }
  end
end
