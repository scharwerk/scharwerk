require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    FileUtils.mkdir_p(Task.tex_path('test/'))
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob(Task.tex_path('')))
  end

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

    it 'updates tex' do
      user = User.create
      sign_in user
      Task.create(stage: :markup, path: 'test/1', status: :active, user: user)
      post :update_tex, tex: '\LaTex{}', format: :json
      expect(user.active_task.tex).to eq('\LaTex{}')
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
