require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #tasks' do
    it 'returns current task' do

      expect(response.body).to_not eq(nil)
    end
  end
end
