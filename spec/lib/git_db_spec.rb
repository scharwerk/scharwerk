require 'rails_helper'

RSpec.describe GitDb do
  before(:all) do
    FileUtils.mkdir_p(File.join(GitDb.path, '/test/'))
    Git.init(GitDb.path)
  end

  after(:all) do
    FileUtils.rm_rf(GitDb.path)
  end

  def write_text(path, text)
    full_path = File.join(GitDb.path, path)
    File.write(full_path, text)
    full_path
  end

  it 'show last commit' do
    g = Git.open(GitDb.path)
    p = write_text('test/1.txt', 'text')
    git = GitDb.new
    git.commit([p], 'message')

    expect(git.latest_commit(p)).to eq(g.log[0].to_s)
  end

  it 'show number of changes' do
    git = GitDb.new
    p = write_text('test/1.txt', "one two next\nthree")
    git.commit([p], 'message')
    p = write_text('test/1.txt', "onetwo next\nfour")
    git.commit([p], 'message')
    changes = git.last_changes(p)

    expect(changes[0]).to eq('-one two')
    expect(changes.count).to eq(4)
  end
end
