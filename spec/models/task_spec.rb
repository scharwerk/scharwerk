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

  describe ".parse_part" do
    it 'return part name' do
      expect(Task.parse_part('public/scharwerk_data/scans/3.2')).to eq 'book_3_2'
    end
  end
  describe ".generate_tasks" do
    it 'generate tasks' do
      task_count = Task.count
      part_pages = []
      21.times do |i|
        page = Page.new
        part_pages.push(page)
      end
      part = 'book_3_2'
      stage = 'first_proof'
      Task.generate_tasks(part_pages, part, stage)
      expect(Task.count).to eq task_count + 2  
    end
  end
end
