require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'shows text' do
    task = Task.create(stage: :first_proof, part: :book_1)
    expect(task.description).to eq('Перша корректура. Капітал. Том І.')
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
end
