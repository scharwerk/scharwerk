require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GEt stats' do
    it 'works' do
      get :stats, stage: 'book', format: :json
      expect(subject.current_user).to eq('error')
    end
  end
end
