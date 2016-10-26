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
end
