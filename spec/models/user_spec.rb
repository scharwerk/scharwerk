require 'rails_helper'

RSpec.describe User, type: :model do
  it 'shows one active task' do
    user = User.create
    task = Task.create(status: :active, user: user)
    expect(user.active_task).to eq(task)
  end

  it 'counts inactive time' do
    user = User.create
    Task.create(status: :commited, user: user)
    sleep(1)
    expect(user.time_inactive).to be > 1
  end

  describe 'user notification' do
    user = User.create

    it 'shows users with no task' do
      status, text = user.notification_message
      expect(status).to eq(:none)
      expect(text).to include('спробуйте виконати одне')
    end

    it 'shows users with active task' do
      Task.create(status: :active, user: user)
      status, text = user.notification_message
      expect(status).to eq(:active)
      expect(text).to include('ви взяли завдання')
    end

    it 'shows users with recent task' do
      Task.create(status: :commited, user: user)
      status, text = user.notification_message
      expect(status).to eq(:recent)
      expect(text).to include('ввійшли у ритм ')
    end
  end
end
