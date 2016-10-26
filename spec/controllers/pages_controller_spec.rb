require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'POST #pages' do
    it 'saves page' do
      user = User.create
      sign_in user
      task = Task.create(stage: :test, status: :active, user: user)
      page1 = task.pages.create(status: :free)
      page2 = task.pages.create(status: :free)

      put :update, id: page1.id, text: 'new text', format: :json
      expect(Page.find(page1.id).text).to eq('new text')

      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq(page2.id)
    end
  end

  describe 'GEt #pages' do
    it 'shows page page' do
      user = User.create
      sign_in user
      task = Task.create(stage: :test, status: :active, user: user)
      page = task.pages.create(status: :free)

      get :show, id: page.id, format: :json
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['id']).to eq(page.id)
    end
  end
end
