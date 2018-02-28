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

  it 'counts finished pages' do
    user = User.create
    t1 = Task.create(status: :commited, user: user)
    t1.pages.create
    t2 = Task.create(status: :unchanged, user: user)
    t2.pages.create
    expect(user.total_pages_done).to eq 2
  end

  describe 'user notification' do
    user = User.create

    it 'shows users with no task' do
      status, _text = user.notification_message
      expect(status).to eq(:none)
    end

    it 'shows users with active task' do
      Task.create(status: :active, user: user)
      status, _text = user.notification_message
      expect(status).to eq(:active)
    end

    it 'shows users with recent task' do
      Task.create(status: :commited, user: user)
      status, _text = user.notification_message
      expect(status).to eq(:recent)
    end
  end
end
