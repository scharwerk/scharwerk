require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST login' do
    it 'works' do
      user = User.create(facebook_id: 123)
      # this is little bit weird
      fb_user = Struct.new(:id).new(123)
      double = instance_double('FbGraph2::User', fetch: fb_user)
      allow(FbGraph2::User).to receive(:me).and_return(double)
      post :login, accessToken: 'some', format: :json
      expect(subject.current_user.id).to eq(user.id)
    end
  end
end
