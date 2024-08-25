class LikesController < ApplicationController
  before_action :authorize
  before_action :check_has_profile
  def create
    @like = Like.new(like_params)
    unless params[:like][:profile_id]
      @like.profile = current_user.profile
    end
    if @like.profile && @like.video
      if current_user.is_owner(@like.profile)
        if @like.save
          render json: @like, status: :created
        else
          render json: @like.errors, status: :unprocessable_entity
        end
      else
        render status: :forbidden
      end
    else
      render json: "Invalid profile_id/video_id", status: :unprocessable_entity
    end
  end

  def destroy
    profile_id = params[:profile_id] || current_user.profile.id
    @like = Like.find_by(profile_id: profile_id, video_id: params[:video_id])
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

  def like_params
    params.require(:like).permit(:profile_id, :video_id)
  end
end
