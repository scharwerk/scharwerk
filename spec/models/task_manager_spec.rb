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
    make_tex('test/1.tex', '\\latex')
    task = TaskManager.generate_task3('test/*', 'franko')[0]
    expect(task.path).to eq('test/1')
    expect(task.tex).to eq('\\latex')
    expect(task.part).to eq('franko')
  end
end