class AuthController < ApplicationController
  #TODO: expire???
  def signup
    @account = Account.new(account_params)
    if @account.save
      render json: {
        'Access-Token': jwt_encode(@account.id),
        'Refresh-Token': jwt_encode_refresh(@account.id)
      }, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def login
    @account = Account.find_by(email: params[:email])
    if @account
      if @account.authenticate(params[:password])
        render json: {
          'Access-Token': jwt_encode(@account.id),
          'Refresh-Token': jwt_encode_refresh(@account.id)
        }, status: :accepted
      else
        head :unauthorized
      end
    else
      render json: "Incorrect email", status: :not_found
    end
  end

  def refresh
    refresh_token = request.headers['Authorization'].split(' ')[1]
    account_id = jwt_decode_refresh(refresh_token)[0]['sub']
    render json: {
      'Access-Token': jwt_encode(account_id)
    }, status: :accepted
  end

  private
  def account_params
    params.permit(:email, :password)
  end
end
