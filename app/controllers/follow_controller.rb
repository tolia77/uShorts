class FollowController < ApplicationController
  before_action :authorize, only: %i[create destory]
  def create
    @follow = Follow.new(follow_params)
    if @follow.follower && @follow.followee
      if current_user.is_owner(@follow.follower) || current_user.is_admin?
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
    @follow = Follow.find_by(follower_id: params[:follower_id], followee_id: params[:followee_id])
    if @follow
      if current_user.is_owner(@follow.follower) || current_user.is_admin?
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
