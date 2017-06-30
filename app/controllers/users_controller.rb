# add top-level class documentation
class UsersController < ApplicationController
  def login
    access_token = params['accessToken']
    status, user = User.login(access_token)
    sign_in(:user, user)

    render json: user, status: status
  end
end
