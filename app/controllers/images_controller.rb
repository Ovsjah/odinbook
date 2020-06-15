class ImagesController < ApplicationController
  def destroy
    image = ActiveStorage::Attachment.where(id: params[:id], record_id: params[:post_id]).take
    image.purge if image&.record&.author == current_user
    render json: { complete: true }, status: 200
  end
end
