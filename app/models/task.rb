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
  has_many :pages, -> { order(:id) }

  attr_accessor :progress
  attr_accessor :current_page
  attr_accessor :description

  enum status: { free: 0, active: 1, done: 2, commited: 3, error: 4 }
  enum stage: { test: 0, first_proof: 1, second_proof: 2 }
  enum part: { book_1: 1, book_2: 2, book_3_1: 3, book_3_2: 4, franko: 5 }

  def description
    I18n.t(part) + '. ' + I18n.t(stage)
  end

  def assign(user)
    update(status: :active, user: user)
  end

  def release
    update(status: :free, user: nil)
    pages.update_all(status: 0)
  end

  def finish
    update(status: :done)
  end

  def commit_message
    stage.to_s + ' T' + id.to_s + ' U' + user.id.to_s
  end

  def commit
    return if commited?

    pathes = pages.collect(&:save_to_file)
    g = Git.open(Rails.configuration.x.data.git_path.to_s)
    g.add(pathes)
    g.commit(commit_message)
    update(status: :commited)
  rescue StandardError
    update(status: :error)
    raise
  end

  def progress
    total = (pages.free.size + pages.done.size)
    total ? BigDecimal.new(pages.done.size) / total : 1
  end

  def current_page
    pages.free.first
  end

  def as_json(options = {})
    super(options.merge(methods: [:description, :progress, :current_page],
                        include: [pages: { only: [:id, :status] }]))
  end

  def self.generate_tasks(part_pages, part, stage, pages_per_task)
    tasks = []
    n = 0
    until n > part_pages.size
      task = Task.create(stage: stage, part: part)
      pages_per_task.times do |i|
        next if part_pages[n + i].nil?
        part_pages[n + i].update(task_id: task.id)
      end
      n += pages_per_task
      tasks.push(task)
    end
    tasks
  end

  def self.unassign_tasks(days_not_updated)
    Task.where("updated_at < ?", Time.now - days_not_updated.day)
    # Client.where("orders_count = ?", params[:orders])
  end
end
