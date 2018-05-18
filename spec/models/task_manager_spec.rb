require 'rails_helper'

RSpec.describe TaskManager do
  def make_tex(path, text)
    File.write(Task.tex_path(path), text)
  end

  before(:each) do
    FileUtils.mkdir_p(Task.tex_path('test/'))
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob(Task.tex_path('')))
  end

  it 'generate tasks' do
    make_tex('test/_0001_0002c.tex', '\\latex')

    task = TaskManager.generate_task3('test/*', 'franko')[0]
    expect(task.path).to eq('test/_0001_0002c')
    expect(task.tex).to eq('\\latex')
    expect(task.part).to eq('franko')
    expect(task.order).to eq(task.id)

    expect(task.pages.count).to eq 2
    expect(task.pages[1].image).to eq '/files/images/test/0002.jpg'
  end
end
