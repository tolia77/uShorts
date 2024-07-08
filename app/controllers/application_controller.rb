class ApplicationController < ActionController::API
  include AuthHelper

  def authorize
    unless authorized?
      head 401
    end
  end

  def check_user_is_admin
    if !current_user.is_admin?
      head 403
    end
  end

  def check_user_is_moderator
    if !current_user.is_admin?
      head 403
    end
  end
end
