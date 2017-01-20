# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  path       :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :integer
#

# add top level class comment
class Page < ActiveRecord::Base
  belongs_to :task

  enum status: { free: 0, done: 1 }

  def self.git_path(path)
    File.join(Rails.configuration.x.data.git_path, path)
  end

  def self.file_path(path)
    File.join(Rails.configuration.x.data.file_path, path)
  end

  def save_to_file
    full_path = self.class.path_join(path)
    File.write(full_path, text)
    full_path.to_s
  end

  # should be moved somewhere else
  def self.add_and_commit(pathes)
    GitWorker.perform_async(pathes)
    # g = Git.open(Rails.configuration.x.data.text_path)
    # g.add(pathes)
    # g.commit('added files')
  end

  def self.create_pages(pattern)
    Dir[git_path(pattern)].sort.collect do |text_file|
      path = text_file[git_path('').length..-5]
      text = File.read(text_file)
      Page.create(path: path, text: text)
    end
  end
end
