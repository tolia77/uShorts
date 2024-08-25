class ApplicationController < ActionController::API
  include AuthHelper

  def authorize
    unless authorized?
      render json: "You need to log in", status: :unauthorized
    end
  end

  def check_user_is_admin
    unless current_user.is_admin?
      render json: "Forbidden", status: :forbidden
    end
  end

  def check_user_is_moderator
    if !current_user.is_moderator?
      render json: "Forbidden", status: :forbidden
    end
  end

  def check_has_profile
    unless current_user.profile
      render json: "You need to create profile", status: :unauthorized
    end
  end
end
