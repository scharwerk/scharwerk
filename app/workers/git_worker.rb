# add top level class documentation
class GitWorker
  include Sidekiq::Worker

  def perform(task_id)
    Task.find(task_id).commit
  end
end
