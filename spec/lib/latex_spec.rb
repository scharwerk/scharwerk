# Replase test data from spec
require 'rails_helper'

RSpec.describe Latex do
  before(:all) do
    FileUtils.mkdir_p(Task.tex_path('test/'))
  end

  after(:all) do
    FileUtils.rm_rf(Dir.glob(Task.tex_path('')))
  end

  it 'converts pdf to pngs' do
    source = File.join(File.dirname(__FILE__), '/../fixtures/', 'sample.pdf')

    Dir.mktmpdir do |path|
      out = File.join(path, 'out')
      Latex.pdf_to_png(source, out)

      expect(File.exist?(path + '/out-1.png')).to be true
      expect(File.exist?(path + '/out-2.png')).to be true
    end
  end

  it 'creates temp latex file' do
    path = Task.tex_path('test/0001.tex')
    Latex.prepare_tex(path)

    p = Task.tex_path('test/0001/main.tex')
    expect(File.exist?(p)).to be true
    expect(File.read(p)).to include '../0001.tex'
  end
end
