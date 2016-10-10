require 'pp'
require 'json'

# add top-level class documentation
class UsersController < ApplicationController
  def login
    access_token = params['accessToken']
    fb_user = FbGraph2::User.me(access_token).fetch(fields: 'id,
      name,
      age_range,
      gender,
      locale,location')

    user = User.find_by(facebook_id: fb_user.id)

    status = :ok
    if user.nil?
      user = User.new
      user.facebook_id = fb_user.id
      user.name = fb_user.name
      user.facebook_data = fb_user.raw_attributes.to_json
      user.save
      status = :created
    end
    sign_in(:user, user)

    render json: user, status: status
  end
end
