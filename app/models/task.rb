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

  has_many :restrictions
  has_many :restricted_users, through: :restrictions, source: :user
  has_many :pages, -> { order(:id) }

  attr_accessor :progress
  attr_accessor :current_page
  attr_accessor :description

  enum status: { free: 0, active: 1, done: 2,
                 commited: 3, error: 4, unchanged: 5 }
  enum stage: { test: 0, first_proof: 1, second_proof: 2 }
  enum part: { book_1: 1, book_2: 2, book_3_1: 3, book_3_2: 4, franko: 5 }

  def description
    I18n.t(part) + '. ' + I18n.t(stage)
  end

  def assign(user)
    update(status: :active, user: user)
  end

  def release
    restrictions.create(user: user)
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
    return unless done?

    pages.each(&:fix_white_space)
    pathes = pages.collect(&:text_file_name)
    status = GitDb.new.commit(pathes, commit_message)

    update(status: status)
  rescue Git::GitExecuteError
    update(status: :error)
    raise
  end

  def progress
    total = (pages.free.size + pages.done.size)
    total ? BigDecimal.new(pages.done.size) / total : 1
  end

  def last_changes_count
    path = pages.first.text_file_name
    GitDb.new.last_changes(path).count
  end

  def current_page
    pages.free.first
  end

  def as_json(options = {})
    super(options.merge(methods: %i[description progress current_page],
                        include: [pages: { only: %i[id status] }]))
  end

  def duplicate
    task = Task.create(stage: stage, part: part, order: order)
    pages.each { |p| task.pages.create(path: p.path) }
    restrictions.each { |r| task.restrictions.create(user: r.user) }
    task.restrictions.create(user: user)
    task
  end

  def self.first_free(stage, user)
    free = Task.where(stage: stage).free
    free.order(:id).each do |task|
      if Restriction.find_by(task_id: task.id, user_id: user.id).blank?
        return task
      end
    end
  end

  # what user worked on page on stage
  def self.blame(stage, path)
    task_ids = Page.where(path: path).pluck(:task_id)
    task = Task.where(id: task_ids, stage: Task.stages[stage]).commited.first
    task.user if task
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

  # generate tasks for second proof
  def self.generate_task2(page, part)
    blame = self.blame(:first_proof, page.path)
    task = Task.create(stage: :second_proof, part: part)
    task.restrictions.create(user: blame) if blame
    task.pages << page
    task
  end

  def self.unassign_tasks(days_not_updated)
    tasks = Task.active.where('updated_at < ?', Time.now - days_not_updated.day)
    tasks.each(&:release)
  end
end
