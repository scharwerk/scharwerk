# add top level class documentation
class GitWorker
  include Sidekiq::Worker

  def perform(pathes)
    g = Git.open(Rails.configuration.x.data.text_path)
    g.add(pathes)
    g.commit('added files')
  end

end
