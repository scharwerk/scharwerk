require 'rails_helper'

RSpec.describe Page, type: :model do
  def path_join(path)
    File.join(Rails.configuration.x.data.git_path, path)
  end

  def make_text(path, text)
    File.write(path_join(path), text)
  end

  before(:all) do
    FileUtils.mkdir_p(path_join('test/'))
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

  it 'commits files' do
    g = Git.init(Rails.configuration.x.data.text_path.to_s)
    File.write(path_join('1/4.txt'), 'book 1 page 4')
    Page.add_and_commit([path_join('1/4.txt')])
    expect(g.log[0].message).to eq('added files')
  end

  describe '.create_pages' do
    it 'return array of new pages' do
      make_text('test/1.txt', '1')

      expect(Page.create_pages('test/*')
                               .class).to eq Array
    end

    it 'return array of object with class page' do
      make_text('test/1.txt', '1')
      make_text('test/2.txt', '2')

      expect(Page.create_pages('test/*')[0]
                               .class).to eq Array
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
      expect(part_pages[random]
        .path.chomp('.jpg')
        .to_i).to be < part_pages[random + 1]
                       .path.chomp('.jpg').to_i
    end
  end
end
