require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  describe 'GET #tasks' do
    it 'returns stats' do
      Task.create(stage: :test, status: :active)
      Task.create(stage: :first_proof, status: :free)
      Task.create(stage: :first_proof, status: :active)
      get :tasks, format: :json
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['first_proof']['active']).to eq(1)
      expect(parsed_body['first_proof']['free']).to eq(1)
      expect(parsed_body['test']['active']).to eq(1)
    end
  end
end
