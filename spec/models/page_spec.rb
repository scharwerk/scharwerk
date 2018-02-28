require 'rails_helper'

RSpec.describe Page, type: :model do
  def make_text(path, text)
    File.write(Page.text_path(path), text)
  end

  before(:each) do
    FileUtils.mkdir_p(Page.text_path('test/'))
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob(Page.text_path('')))
  end

  it 'saves text to file on set' do
    Page.create(path: 'test/4', text: 'book 4')
    expect(File.read(Page.text_path('test/4.txt'))).to eq('book 4')
  end

  it 'fixes whitespace' do
    page = Page.create(path: 'test/4', text: "\t book 4 ")
    page.fix_white_space
    expect(page.text).to eq("     book 4\n")
  end

  describe '.create_pages' do
    it 'return array of new pages' do
      make_text('test/1.txt', '1')
      make_text('test/2.txt', '2')

      expect(Page.create_pages('test/*').class).to eq Array
    end

    it 'return save pages text and path' do
      make_text('test/3.txt', '3')

      page = Page.create_pages('test/*')[0]
      expect(page.text).to eq '3'
      expect(page.path).to eq 'test/3'
    end
  end
end
