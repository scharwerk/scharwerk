# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  status     :integer
#  stage      :integer
#  part       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# add top level class documentation
class Task < ActiveRecord::Base
  belongs_to :user
  has_many :pages

  attr_accessor :progress
  attr_accessor :current_page
  attr_accessor :description

  enum status: { free: 0, active: 1, done: 2, commited: 3 }
  enum stage: { test: 0, first_proof: 1, second_proof: 2 }
  enum part: { book_1: 1, book_2: 2, book_3_1: 3, book_3_2: 4, franko: 5 }

  def description
    I18n.t(stage) + ' ' + I18n.t(part)
  end

  def assign(user)
    update(status: :active, user: user)
  end

  def release
    update(status: :free, user: nil)
    pages.update_all(status: 0)
  end

  def progress
    total = (pages.free.size + pages.done.size)
    total ? BigDecimal.new(pages.done.size) / total : 1
  end

  def current_page
    pages.free.first
  end

  def as_json(options = {})
    super(options.merge(
            methods: [:description, :progress, :current_page],
            include: [pages: { only: [:id, :status] }]
    ))
  end

  def self.generate_tasks(part_pages, part, stage, pages_per_task)
    n = 0
    until n > part_pages.size do
      task = Task.new
      task.stage = stage
      task.part = part
      task.save
      pages_per_task.times do |i|
        next if part_pages[n + i] == nil
        part_pages[n + i].update(task_id: task.id)
      end
      n += pages_per_task
    end
  end

end
