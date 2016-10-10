require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GEt stats' do
    it 'works' do
      Task.create(stage: :first_proof, status: :not_started)
      Task.create(stage: :first_proof, status: :in_progress)
      get :stats, stage: 'first_proof', format: :json
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['0']).to eq(1)
      expect(parsed_body['1']).to eq(1)
    end
  end
end
