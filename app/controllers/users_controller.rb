class UsersController < ApplicationController

  def login
    user = User.create()
    sign_in(:user, user)
    render json: params.require(:auth)
  end

end
