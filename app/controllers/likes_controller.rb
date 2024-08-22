class LikesController < ApplicationController
  before_action :authorize
  def create
    @like = Like.new(profile_id: params[:profile_id], video_id: params[:video_id])
    if current_user.is_owner(@like.profile)
      if @like.save
        render status: :created
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    else
      render status: :forbidden
    end
  end

  def destroy
    @like = Like.find_by(profile_id: params[:profile_id], video_id: params[:video_id])
    if @like
      if current_user.is_owner(@like.profile)
        @like.destroy
        render status: :no_content
      else
        render status: :forbidden
      end
    else
      render status: :not_found
    end
  end
end
