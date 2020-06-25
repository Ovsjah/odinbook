class ImagesController < ApplicationController
  def destroy
    if params[:post_id]
      image = ActiveStorage::Attachment.where(id: params[:id], record_id: params[:post_id]).take
      image.purge if image&.record&.author == current_user
      render json: { complete: true }, status: 200
    else
      current_user.avatar.purge if current_user.avatar.id == params[:id].to_i
      render template: 'users/edit'
    end
  end
end
