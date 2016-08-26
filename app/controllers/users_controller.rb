class UsersController < ApplicationController

  def login
    render json: params.require(:auth)
  end

end
