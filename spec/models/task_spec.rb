require 'rails_helper'

RSpec.describe Task, type: :model do
  before(:all) do
    FileUtils.mkdir_p(Page.text_path('test/'))
  end

  after(:all) do
    FileUtils.rm_r(Page.text_path('../.git/'))
    FileUtils.rm_rf(Dir.glob(Page.text_path('')))
  end

  it 'shows text' do
    task = Task.create(stage: :first_proof, part: :book_1)
    expect(task.description).to eq('Капітал, том І. Перша корректура')
  end

  it 'calculates progress' do
    task = Task.create
    task.pages.create(status: :free)
    task.pages.create(status: :free)
    task.pages.create(status: :done)
    expect(task.progress).to eq(BigDecimal.new(1) / 3)
  end

  it 'show curent page' do
    task = Task.create
    task.pages.create(status: :done)
    task.pages.create(status: :done)
    current = task.pages.create(status: :free)
    expect(task.current_page).to eq(current)
  end


  it 'commit files' do
    g = Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :done, user: User.create)
    task.pages.create(status: :done, path: 'test/1', text: '1')
    task.pages.create(status: :done, path: 'test/2', text: '2')
    task.commit

    expect(g.log[0].message).to start_with('test ')
  end

  describe '.generate_tasks' do
    it 'generate tasks' do
      task_count = Task.count
      part_pages = []
      21.times do
        page = Page.new
        part_pages.push(page)
      end
      part = 'book_3_2'
      stage = 'first_proof'
      pages_per_task = 20
      Task.generate_tasks(part_pages, part, stage, pages_per_task)
      expect(Task.count).to eq task_count + 2
    end
    it 'generate task with proper number of pages' do
      part_pages = []
      21.times do
        page = Page.new
        part_pages.push(page)
      end
      part = 'book_3_2'
      stage = 'first_proof'
      pages_per_task = 10
      Task.generate_tasks(part_pages, part, stage, pages_per_task)
      expect(Page.where(task_id: Task.first.id).count).to eq pages_per_task
    end
  end

  describe '.release' do
    it 'change status to :free' do
      task = Task.new
      task.assign(User.last)
      task.release

      expect(task.status).to eq 'free'
    end

    it 'change user_id to nil' do
      task = Task.new
      task.assign(User.last)
      task.release

      expect(task.user_id).to eq nil
    end

    it 'releses task page' do
	  task = Task.create(user: User.create, status: :active)
      task.release
      expect(task.status).to eq('free')
      expect(task.user).to eq(nil)
    end

    it 'frees pages on task release' do
      task = Task.create(status: :active)
      page = task.pages.create(status: :done)
      task.pages.create(status: :free)
      task.release
      expect(Page.find(page.id).status).to eq('free')
    end
    
  end


  describe '.unassign_abandoned' do
    context 'with task, that havent been updated more than N days' do
      it 'change status to free ' do
        task = Task.new
        task.assign(User.last)
        task.updated_at = "2009-08-15 18:05:44"
        task.save

        Task.unassign_tasks(60)

        expect(Task.last.status).to eq 'free'
      end
    end

    context 'with task, that have been updated in last N days' do
      it 'should live status active' do
        task = Task.new
        task.assign(User.last)
        task.updated_at = Time.now - 1.day
        task.save

        Task.unassign_tasks(60)

        expect(Task.last.status).to eq 'active'
        
      end
    end
  end
end
