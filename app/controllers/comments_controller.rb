class CommentsController < ApplicationController
  before_action :get_comment, only: %i[update destroy]

  def create
    comment = current_user.comments.build(comment_params)

    if comment.save
      render json: comment, status: 201
    else
      redirect_to root_path, flash: { danger: "Your comment hasn't been posted, please try again." }
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment, status: 201
    else
      redirect_to root_path, flash: { danger: "Your comment hasn't been updated, please try again." }
    end
  end

  def destroy
    @comment&.destroy
    render json: { complete: true }, status: 200
  end

  private

    def get_comment
      @comment = current_user.comments.find_by_id(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end
end
