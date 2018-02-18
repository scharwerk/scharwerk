# store texts in git
class GitDb
  def self.path
    Rails.configuration.x.data.git_path.to_s
  end

  def initialize
    @git = Git.open(self.class.path)
  end

  def commit(pathes, message)
    @git.add(pathes)
    @git.commit(message)
    return :commited
  rescue Git::GitExecuteError => e
    return :unchanged if e.message.include? 'nothing to commit'

    raise
  end

  def latest_commit(path)
    @git.log(1).object(path).first.to_s
  end

  def last_changes(path)
    commit = latest_commit(path)
    lines = @git.lib.diff_full(commit + '^!', '--word-diff=porcelain')
    lines.split(/\n+/).grep(/^[\+\-][^\+\-]/)
  end
end