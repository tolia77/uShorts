class FollowsController < ApplicationController
  before_action :authorize
  before_action :check_has_profile
  def create
    @follow = Follow.new(follow_params)
    unless params[:follow][:follower_id]
      @follow.follower = current_user.profile
    end
    if @follow.follower && @follow.followee
      if current_user.is_owner(@follow.follower)
        if @follow.save
          render status: :created
        else
          render json: @follow.errors, status: :unprocessable_entity
        end
      else
        render status: :forbidden
      end
    else
      render status: :unprocessable_entity
    end

  end

  def destroy
    follower_id = params[:follow][:follower_id] || current_user.profile.id
    @follow = Follow.find_by(follower_id: follower_id, followee_id: params[:follow][:followee_id])
    if @follow
      if current_user.is_owner(@follow.follower)
      @follow.destroy
        render status: :no_content
      else
        render status: :forbidden
      end
    else
      render status: :not_found
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def follow_params
    params.require(:follow).permit(:follower_id, :followee_id)
  end
end
