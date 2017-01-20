# add top level class documentation
class GitWorker
  include Sidekiq::Worker

  def perform(pathes)
    g = Git.open(Rails.configuration.x.data.text_path)
    g.add(pathes)
    g.commit('added files')
  end
end

  # it 'commits files' do
  #   g = Git.init(Rails.configuration.x.data.text_path.to_s)
  #   File.write(path_join('1/4.txt'), 'book 1 page 4')
  #   Page.add_and_commit([path_join('1/4.txt')])
  #   expect(g.log[0].message).to eq('added files')
  # end
  # 
  #     FileUtils.rm_r(path_join('.git/'))
  #     
  #       # should be moved somewhere else
  # def self.add_and_commit(pathes)
  #   GitWorker.perform_async(pathes)
  #   # g = Git.open(Rails.configuration.x.data.text_path)
  #   # g.add(pathes)
  #   # g.commit('added files')
  # end