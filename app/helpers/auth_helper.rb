# frozen_string_literal: true

module AuthHelper
  def jwt_encode(payload)
    JWT.encode(payload, Rails.application.credentials.auth.jwt_secret)
  end

  def jwt_decode(token)
      begin
        return JWT.decode(token, Rails.application.credentials.auth.jwt_secret)
      rescue
        nil
      end
  end

  def authorized?
    !!jwt_decode(request.headers['Authorization'].split(' ')[1])
  end

  def current_user
    id = jwt_decode(request.headers['Authorization'].split(' ')[1])
    if id
      return Account.find(id)
    end
    nil
  end
end
