class AuthController < ApplicationController
  def signup
    @account = Account.new(account_params)
    if @account.save
      jti = generate_jti
      @session = Session.new(account: @account, jti: jti)
      render json: {
        'Access-Token': jwt_encode(@account.id),
        'Refresh-Token': jwt_encode_refresh(@account.id, jti=jti)
      }, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def login
    @account = Account.find_by(email: params[:email])
    if @account
      if @account.authenticate(params[:password])
        jti = generate_jti
        @session = Session.new(account: @account, jti: jti)
        render json: {
          'Access-Token': jwt_encode(@account.id),
          'Refresh-Token': jwt_encode_refresh(@account.id, jti=jti)
        }, status: :accepted
      else
        render plain: "Wrong password", status: :unauthorized
      end
    else
      render plain: "Incorrect email", status: :not_found
    end
  end

  def refresh
    begin
      refresh_token = request.headers['Authorization'].split(' ')[1]
      account_id = jwt_decode_refresh(refresh_token)[0]['sub']
      if Session.find_by(jti: jwt_decode_refresh(refresh_token)[0]['jti'])
        render plain: "Session is blocked", status: :unauthorized
      else
        render json: {
          'Access-Token': jwt_encode(account_id)
        }, status: :accepted
      end
    rescue
      render plain: "Invalid token", status: :unprocessable_entity
    end
  end

  def logout
    begin
      refresh_token = request.headers['Authorization'].split(' ')[1]
      decoded = jwt_decode_refresh(refresh_token)[0]
      account = Account.find(decoded['sub'])
      session = Session.new(account_id: account.id, jti: decoded['jti'])
      if session.save
        render plain: "Successfully logged out", status: :ok
      else
        render session.errors, status: :unprocessable_entity
      end
    rescue
      render plain: "Invalid token", status: :unprocessable_entity
    end
  end

  private
  def account_params
    params.permit(:email, :password)
  end
end
