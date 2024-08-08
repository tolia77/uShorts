class PagesController < ApplicationController
  before_action :authorize, only: :protected
  def index
  end

  def protected
    render status: 200
  end
end
