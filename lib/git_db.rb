class GitDb

  def initialize()
  	path = Rails.configuration.x.data.git_path.to_s
    @git = Git.open(path)
  end

  def commit(pathes, message)
    @git.add(pathes)
    @git.commit(message)
    return :ok
  rescue Git::GitExecuteError => e
    return :unchanged if e.message.include? 'nothing to commit'

    raise
  end

end