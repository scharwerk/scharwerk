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

  def text_file_name
    Page.text_path(path + '.txt')
  end

  def text=(text)
    File.write(text_file_name, text)
  end

  def text
    File.read(text_file_name)
  end

  def self.create_pages(pattern)
    Dir[text_path(pattern)].sort.collect do |text_file|
      path = text_file[text_path('').length..-5]
      Page.create(path: path)
    end
  end

  def as_json(options = {})
    super(options.merge(methods: [:image]))
  end
end
