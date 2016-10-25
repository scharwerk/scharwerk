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
  end

  describe 'DELETE #tasks' do
    it 'releases task' do
      user = User.create
      sign_in user
      Task.create(stage: :test, status: :active, user: user)
      delete :destroy, format: :json
      expect(user.active_task).to eq(nil)
    end
  end
end
