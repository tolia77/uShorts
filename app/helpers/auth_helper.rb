# frozen_string_literal: true

module AuthHelper
  def jwt_encode(payload)
    JWT.encode(payload, Rails.application.credentials.auth.jwt_secret, "HS256")
  end

  def jwt_decode(token)
      JWT.decode(token, Rails.application.credentials.auth.jwt_secret, true, { :algorithm => 'HS256' })
  end

  def authorized?
    header = request.headers['Authorization']
    unless header
      return nil
    end
    !!jwt_decode(header.split(' ')[1])
  end

  def current_user
    header = request.headers['Authorization']
    unless header
      return nil
    end
    id = jwt_decode(header.split(' ')[1])[0]['data']
    if id
      Account.find(id)
    end
  end
end
