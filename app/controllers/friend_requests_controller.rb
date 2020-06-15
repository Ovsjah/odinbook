class FriendRequestsController < ApplicationController
  before_action :find_friend_request, only: %i[accept deny]

  def accept
    current_user.accept_friend_request(@friend_request)
    redirect_to(
      root_path,
      flash: { notice: "Congrats! You are friends with <b>#{@friend_request.sender.username}</b> now.".html_safe }
    )
  end

  def deny
    redirect_to(
      root_path,
      flash: {
        notice: "The friend request from"\
          " <b>#{@friend_request.destroy.sender.username}</b>"\
          " was successfully deleted.".html_safe
      }
    )
  end

  def send_request
    receiver = User.find(params[:id])
    current_user.send_friend_request(receiver)
    redirect_to(
      root_path,
      flash: { notice: "You've successfully sent a friend request to <b>#{receiver.username}</b>.".html_safe }
    )
  end

  private

    def find_friend_request
      @friend_request = current_user.received_friend_requests.find(params[:id])
    end
end
