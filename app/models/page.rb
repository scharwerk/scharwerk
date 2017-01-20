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

  def self.path_join(path)
    File.join(Rails.configuration.x.data.text_path, path)
  end

  def save_to_file
    full_path = self.class.path_join(path)
    File.write(full_path, text)
    full_path.to_s
  end

  def self.load_from_file(path)
    page = where(path: path).first_or_create
    page.text = File.read(path_join(path))
    page.save
  end

  # should be moved somewhere else
  def self.add_and_commit(pathes)
    GitWorker.perform_async(pathes)
    # g = Git.open(Rails.configuration.x.data.text_path)
    # g.add(pathes)
    # g.commit('added files')
  end

  def self.create_pages(scans_path, texts_path)
    part_pages = []
    Dir.foreach(scans_path) do |item|
      # 'public/scharwerk_data/scans/3.2'
      next if item == '.' || item == '..'
      page = Page.create(path: item)
      number = item.delete('.jpg')
      page.text = File.read(texts_path + "/#{number}.txt")
      page.save
      part_pages.push(page)
    end
    part_pages.sort_by { |page| page.path.chomp('.jpg').to_i }
  end
end
