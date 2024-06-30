class AuthController < ApplicationController
  def signup
    @account = Account.new(account_params)
    if @account.save
      render json: {
        Authorization: jwt_encode(@account.id),
        Account: @account.to_json
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
          Authorization: jwt_encode(@account.id),
          Account: @account.to_json
        }, status: :accepted
      else
        head :unauthorized
      end
    else
      render json: "Incorrect email", status: :not_found
    end
  end

  private
  def account_params
    params.permit(:email, :password)
  end
end
