require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'POST #tasks' do
    it 'assign task' do
      user = User.create
      sign_in user
      task = Task.create(stage: :test, status: :free)
      post :create, stage: :test, format: :json
      expect(user.active_task).to eq(task)
    end

    it 'denies two tasks assigment' do
      user = User.create
      sign_in user
      Task.create(stage: :test, status: :active, user: user)
      post :create, stage: :test, format: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'DELETE #tasks' do
    it 'releases task' do
      user = User.create
      sign_in user
      Task.create(stage: :test, status: :active, user: user)
      delete :destroy, format: :json
      expect(user.active_task).to eq(nil)
    end

    it 'releases task and assign next' do
      user = User.create
      sign_in user
      Task.create(stage: :test, status: :active, user: user)
      task = Task.create(stage: :test, status: :free)
      delete :destroy, next: true, format: :json
      expect(user.active_task).to eq(task)
    end
  end
end
