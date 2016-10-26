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
end
