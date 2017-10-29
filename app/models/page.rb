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

  def text=(text)
    # write_to_file(text)
    full_path = Page.text_path(path) + '.txt'
    File.write(full_path, text)
    full_path
  end

  def text
    full_path = Page.text_path(path) + '.txt'
    File.read(full_path)
  end

  def self.text_path(path)
    File.join(
      Rails.configuration.x.data.git_path,
      Rails.configuration.x.data.text_folder,
      path
    )
  end

  def self.file_path(path)
    File.join(Rails.configuration.x.data.file_path, path)
  end

  def image
    Rails.configuration.x.data.images_url + path + '.jpg'
  end

  def save_to_file
    full_path = Page.text_path(path) + '.txt'
    File.write(full_path, text)
    full_path
  end

  def self.create_pages(pattern)
    Dir[text_path(pattern)].sort.collect do |text_file|
      path = text_file[text_path('').length..-5]
      text = File.read(text_file)
      Page.create(path: path, text: text)
    end
  end

  def as_json(options = {})
    super(options.merge(methods: [:image]))
  end
end
