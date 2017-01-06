require 'rails_helper'

RSpec.describe Page, type: :model do
  def path_join(path)
    File.join(Rails.configuration.x.data.text_path, path)
  end

  before(:all) do
    FileUtils.mkdir_p(path_join('1/'))
  end

  after(:all) do
    FileUtils.rm_rf(Dir.glob(path_join('*')))
    FileUtils.rm_r(path_join('.git/'))
  end

  it 'saves text to file' do
    page = Page.create(path: '1/2.txt', text: 'book 1 page 1')
    page.save_to_file
    expect(File.read(path_join('1/2.txt'))).to eq('book 1 page 1')
  end

  it 'loads file to new page' do
    File.write(path_join('1/3.txt'), 'book 1 page 3')
    Page.load_from_file('1/3.txt')
    expect(Page.where(path: '1/3.txt').first.text).to eq('book 1 page 3')
  end

  it 'updates page text from file' do
    Page.create(path: '1/4.txt', text: 'old text')
    File.write(path_join('1/4.txt'), 'book 1 page 4')
    Page.load_from_file('1/4.txt')
    expect(Page.where(path: '1/4.txt').first.text).to eq('book 1 page 4')
  end

  it 'commits files' do
    g = Git.init(Rails.configuration.x.data.text_path.to_s)
    File.write(path_join('1/4.txt'), 'book 1 page 4')
    Page.add_and_commit([path_join('1/4.txt')])
    expect(g.log[0].message).to eq('added files')
  end

  describe '.create_pages' do
    it 'return array of new pages' do
      expect(Page.create_pages('public/scharwerk_data/scans/3.2',
        'public/scharwerk_data/texts/3.2').class).to eq Array
    end
    it 'return array of object with class page' do
      expect(Page.create_pages('public/scharwerk_data/scans/3.2',
        'public/scharwerk_data/texts/3.2')[0].class). to eq Page
    end
    it 'save new pages' do
      page_count = Page.count
      Page.create_pages('public/scharwerk_data/scans/3.2',
        'public/scharwerk_data/texts/3.2')
      expect(Page.count).to be > page_count
    end
    it 'return sorted, by page number, array of pages' do
      part_pages = Page.create_pages('public/scharwerk_data/scans/3.2',
        'public/scharwerk_data/texts/3.2')
      random = rand(0...(part_pages.size - 1))
      expect(part_pages[random].path.chomp('.jpg').to_i).to be < 
        part_pages[random + 1].path.chomp('.jpg').to_i
    end
  end
end
