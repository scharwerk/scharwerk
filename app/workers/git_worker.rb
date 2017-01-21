# add top level class documentation
class GitWorker
  include Sidekiq::Worker

  def perform(task)
    task.commit
  end
end
