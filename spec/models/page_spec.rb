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

  it 'saves text to file' do
    page = Page.create(path: 'test/4', text: 'book 4')
    page.save_to_file
    expect(File.read(Page.text_path('test/4.txt'))).to eq('book 4')
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

  describe '#text' do
    it 'save text to file' do
      page = Page.create(path: 'test/4')
      text_to_save = 'book 4'
      page.text = text_to_save

      expect(File.read(Page.text_path('test/4.txt'))).to eq('book 4')
    end

    it 'read text from file' do
      make_text('test/5.txt', 'book 5')
      page = Page.create(path: 'test/5')

      expect(page.text).to eq('book 5')
    end
  end
end
