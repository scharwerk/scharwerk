require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'shows text' do
    info = Task.create(stage: :first_proof, part: :book_1).info
    expect(info[:description]).to eq('Перша корректура. Капітал. Том І.')
  end
end
