class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show update destroy ]
  before_action :authorize, only: %i[ index create update destroy ]
  before_action :check_user_is_moderator, only: %i[ index ]
  # GET /profiles
  def index
    @profiles = Profile.all
    render json: @profiles
  end

  def search
    key = params[:key]
    page = params[:page].to_i - 1
    @profiles = Profile.where("name LIKE ?", "%#{key}%").offset(10 * page).limit(10)
    render json: @profiles, status: :ok
  end

  # GET /profiles/1
  def show
    render json: @profile
  end

  # POST /profiles
  def create
    if current_user.profile
      render json: "Profile already exists", status: :conflict
    else
      @profile = current_user.build_profile(profile_params)
      if @profile.save
        render json: @profile, status: :created, location: @profile
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /profiles/1
  def update
    if current_user.is_owner(@profile) || current_user.is_moderator?
      if @profile.update(profile_params)
        render json: @profile
      else
        render json: @profile.errors, status: :unprocessable_entity
      end
    else
      render status: :forbidden
    end

  end

  # DELETE /profiles/1
  def destroy
    if current_user.is_owner(@profile)
      @profile.destroy
    else
      render status: :forbidden
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find_by(name: params[:name])
      unless @profile
        render status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:name, :description, :account_id, :avatar)
    end
end
