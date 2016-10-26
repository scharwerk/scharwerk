require 'rails_helper'

RSpec.describe User, type: :model do
  it 'shows one active task' do
    user = User.create
    task = Task.create(status: :active, user: user)
    expect(user.active_task).to eq(task)
  end
end
