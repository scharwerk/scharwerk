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

  enum status: { free: 0, active: 1, done: 2,
                 commited: 3, error: 4, unchanged: 5,
                 reproof: 6, delaуed: 7 }
  enum stage: { test: 0, first_proof: 1, second_proof: 2,
                markup: 3, markup_complex: 4 }
  enum part: { book_1: 1, book_2: 2, book_3_1: 3, book_3_2: 4, franko: 5 }
  enum build: { undefined: 0, success: 1, fail: 2 }

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

  def any_markup?
    markup? or markup_complex?
  end

  def commit
    return unless done?

    pathes = any_markup? ? [tex_file_name] : pages.collect(&:text_file_name)

    status, commit_id = GitDb.new.commit(pathes, commit_message)

    update(status: status, commit_id: commit_id)
    validate
  rescue Git::GitExecuteError
    update(status: :error)
    raise
  end

  def validate
    return if markup_complex?
    return if (markup? && line_diff_count < 25) ||
              ((not markup?) && word_diff_count < 11)
    update(status: :reproof)
    duplicate
  end

  def progress
    total = (pages.free.size + pages.done.size)
    total ? BigDecimal.new(pages.done.size) / total : 1
  end

  def word_diff_count
    return 0 unless commited?
    GitDb.new.word_diff(commit_id).count
  end

  def line_diff_count
    return 0 unless commited?
    GitDb.new.line_diff_count(commit_id)
  end

  def current_page
    pages.free.first
  end

  def as_json(options = {})
    methods = if any_markup?
                %i(description tex images)
              else
                %i(description progress current_page)
              end
    super(options.merge(methods: methods,
                        include: [pages: { only: %i(id image status),
                                           methods:  %i(image) }]))
  end

  def duplicate
    task = Task.create(stage: stage, part: part, order: order)
    pages.each { |p| task.pages.create(path: p.path) }
    restrictions.each { |r| task.restrictions.create(user: r.user) }
    task.restrictions.create(user: user)
    task
  end

  def self.tex_path(path)
    File.join(
      Rails.configuration.x.data.git_path,
      Rails.configuration.x.data.tex_folder,
      path
    )
  end

  def tex_file_name
    Task.tex_path(path + '.tex')
  end

  def tex=(tex)
    update(build: :undefined)
    File.write(tex_file_name, tex)
  end

  def images_path
    File.join(Rails.configuration.x.data.preview_path, path)
  end

  def update_preview
    update(build: Latex.build(path, images_path, tex_file_name))
  end

  def tex
    File.read(tex_file_name)
  end

  def self.done_statuses
    [statuses[:commited], statuses[:unchanged], statuses[:reproof]]
  end

  def images
    url = Rails.configuration.x.data.preview_url
    Dir[images_path + '/*'].collect do |image|
      url + path + '/' + File.basename(image)
    end.sort
  end

  def self.first_free(stage, user)
    free = Task.where(stage: stage).free
    free.order(:order, :id).each do |task|
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
