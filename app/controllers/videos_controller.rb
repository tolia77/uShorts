class VideosController < ApplicationController
  before_action :authorize, only: %i[create update destroy]
  before_action :check_has_profile, only: :create
  before_action :set_video, only: %i[show update destroy]
  def index
    render json: Video.all
  end

  def search
    key = params[:key]
    page = params[:page].to_i - 1
    @videos = Video.where("description LIKE ?", "%#{key}%").offset(10 * page).limit(10)
    render json: @videos, status: :ok
  end

  def show
    render json: @video
  end

  def create
    @video = current_user.profile.videos.build(video_params)
    if @video.save
      render json: @video, status: :created, location: @video
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user.is_owner(@video.profile) || current_user.is_moderator?
      if @video.update(video_params)
        render json: @video
      else

      end
    else
      render status: :forbidden
    end
  end

  def destroy
    if current_user.is_owner(@video.profile) || current_user.is_moderator?
      @video.destroy
    else
      render status: :forbidden
    end
  end

  private
  def video_params
    params.require(:video).permit(:description, :source, :profile_id)
  end

  def set_video
    begin
      @video = Video.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found
    end
  end
end
