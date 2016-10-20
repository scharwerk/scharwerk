require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST login' do
    it 'works' do
      post :login, accessToken: 'some', format: :json
      expect(subject.current_user).to eq(nil)
    end
  end
end
