# frozen_string_literal: true

module AuthHelper
  def jwt_encode(sub, exp=Time.now.to_i + 120)
    JWT.encode({sub: sub, exp: exp, iat: Time.now.to_i}, Rails.application.credentials.auth.jwt_access_secret, "HS256")
  end

  def jwt_decode(token)
      JWT.decode(token, Rails.application.credentials.auth.jwt_access_secret, true, { :algorithm => 'HS256' })
  end

  def jwt_encode_refresh(sub, exp=Time.now.to_i + 3600 * 24 * 30)
    JWT.encode({sub: sub, exp: exp, iat: Time.now.to_i}, Rails.application.credentials.auth.jwt_refresh_secret, "HS256")
  end

  def jwt_decode_refresh(token)
    JWT.decode(token, Rails.application.credentials.auth.jwt_refresh_secret, true, { :algorithm => 'HS256' })
  end

  def authorized?
    header = request.headers['Authorization']
    return token_valid?(header)
  end

  def current_user
    header = request.headers['Authorization']
    unless token_valid?(header)
      return nil
    end
    id = jwt_decode(header.split(' ')[1])[0]['sub']
    if id
      Account.find(id)
    end
  end

  def token_valid?(token)
    unless token
      return false
    end
    begin
      decoded = jwt_decode(token.split(' ')[1])
    rescue
      return false
    end
    return true
  end
end
