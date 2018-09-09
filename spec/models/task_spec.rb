require 'rails_helper'

RSpec.describe Task, type: :model do
  before(:all) do
    FileUtils.mkdir_p(Page.text_path('test/'))
    FileUtils.mkdir_p(Task.tex_path('test/'))
  end

  after(:all) do
    FileUtils.rm_r(Page.text_path('../.git/'))
    FileUtils.rm_rf(Dir.glob(Page.text_path('')))
    FileUtils.rm_rf(Dir.glob(Task.tex_path('')))
  end

  it 'shows text' do
    task = Task.create(stage: :first_proof, part: :book_1)
    expect(task.description).to eq('Капітал, том І. Перша коректура')
  end

  it 'saves tex to file on set' do
    Task.create(path: 'test/4', tex: '\\latex{}')
    expect(File.read(Task.tex_path('test/4.tex'))).to eq('\\latex{}')
  end

  it 'calculates progress' do
    task = Task.create
    task.pages.create(status: :free)
    task.pages.create(status: :free)
    task.pages.create(status: :done)
    expect(task.progress).to eq(BigDecimal.new(1) / 3)
  end

  it 'show curent page' do
    task = Task.create
    task.pages.create(status: :done)
    task.pages.create(status: :done)
    current = task.pages.create(status: :free)
    expect(task.current_page).to eq(current)
  end

  it 'blames user' do
    u = User.create
    task = Task.create(status: :commited, user: u, stage: :first_proof)
    task.pages.create(path: 'test/1.txt')
    expect(Task.blame(:first_proof, 'test/1.txt')).to eq(u)
  end

  it 'not blames user' do
    expect(Task.blame(:first_proof, 'test/1.txt')).to eq(nil)
  end

  it 'commit files' do
    g = Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :done, user: User.create)
    task.pages.create(status: :done, path: 'test/1', text: '1')
    task.pages.create(status: :done, path: 'test/2', text: '2')
    task.commit

    expect(g.log[0].message).to start_with('test ')
    expect(task.commit_id.length).to eq(40)
  end

  it 'commits tex files' do
    g = Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :done, user: User.create, stage: :markup, path: 'test/4', tex: '\\latex')
    task.commit

    expect(task.commit_id.length).to eq(40)
  end


  it 'commit only done' do
    Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :free)
    task.commit

    expect(task.status).to eq 'free'
  end

  it 'set status to unchanged' do
    Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :done, user: User.create)
    task.commit

    expect(task.status).to eq 'unchanged'
  end

  it 'fixes whitespce before commit' do
    Git.init(Rails.configuration.x.data.git_path.to_s)

    task = Task.create(status: :done, user: User.create)
    text = "\ttext\n\nnew paragraph "
    page = task.pages.create(status: :done, path: 'test/1', text: text)
    task.commit

    expect(page.text).to eq "    text\n\nnew paragraph\n"
  end

  it 'duplicates task' do
    u1 = User.create
    u2 = User.create

    task = Task.create(status: :done, user: u2, order: 10, part: :book_1)
    task.restrictions.create(user: u1)
    task.pages.create(status: :done, path: 'test/1')

    task2 = task.duplicate

    expect(task2.order).to eq task.order
    expect(task2.restrictions.count).to eq 2
    expect(task2.pages.first.path).to eq 'test/1'
  end

  it 'creates reproof markup task' do
    task = Task.create(status: :done,
                       user: User.create,
                       path: 'test/1',
                       part: :book_1,
                       stage: :markup,
                       order: 100)
    task.tex = 'tex1'
    task.commit
    
    allow_any_instance_of(GitDb).to receive(:line_diff_count).and_return(26)

    task.update(status: :done)
    task.tex = 'tex2'
    task2 = task.commit

    expect(task.status).to eq 'reproof'
    expect(task2.status).to eq 'free'
    expect(task2.path).to eq 'test/1'
    expect(task2.order).to eq 100
    expect(task2.user).to eq nil
  end

  it 'creates reproof task' do
    task = Task.create(status: :done,
                       user: User.create,
                       part: :book_1,
                       order: 100)
    page = task.pages.create(status: :done, path: 'test/1')
    # try to create 11 words diff
    page.text = 'w1 w2 w3 w4 w6 w7 w8 w9 w10 w5 w7 w13 w15'
    task.commit
    task.update(status: :done)
    page.text = 'w1 w8 w3 w6 w5 w7 w9 w11 w10 w12 w7 w11 w15 w17'
    task2 = task.commit

    expect(task.status).to eq 'reproof'
    expect(task2.status).to eq 'free'
    expect(task2.order).to eq 100
    expect(task2.user).to eq nil
  end

  describe '.generate_tasks' do
    it 'generate tasks' do
      task_count = Task.count
      part_pages = []
      21.times do
        page = Page.new
        part_pages.push(page)
      end
      part = 'book_3_2'
      stage = 'first_proof'
      pages_per_task = 20
      Task.generate_tasks(part_pages, part, stage, pages_per_task)
      expect(Task.count).to eq task_count + 2
    end
    it 'generate task with proper number of pages' do
      part_pages = []
      21.times do
        page = Page.new
        part_pages.push(page)
      end
      part = 'book_3_2'
      stage = 'first_proof'
      pages_per_task = 10
      Task.generate_tasks(part_pages, part, stage, pages_per_task)
      expect(Page.where(task_id: Task.first.id).count).to eq pages_per_task
    end
  end

  describe '.generate_tasks_2' do
    it 'generate tasks' do
      page = Page.create(status: :free)
      task = Task.generate_task2(page, 'book_3_2')

      expect(task.pages.count).to eq 1
      expect(task.restrictions.empty?).to eq true
    end
  end

  describe '.release' do
    it 'releses task page' do
      user = User.create
      task = Task.create(user: user, status: :active)
      task.release
      expect(task.status).to eq('free')
      expect(task.user).to eq(nil)
      expect(task.restricted_users.exists?(user.id)).to eq(true)
    end

    it 'frees pages on task release' do
      task = Task.create(status: :active)
      page = task.pages.create(status: :done)
      task.pages.create(status: :free)
      task.release
      expect(Page.find(page.id).status).to eq('free')
    end
  end

  describe '.unassign_abandoned' do
    context 'with task, that havent been updated more than N days' do
      it 'change status to free ' do
        task = Task.new
        task.assign(User.create)
        task.updated_at = '2009-08-15 18:05:44'
        task.save

        Task.unassign_tasks(60)

        expect(Task.find(task.id).status).to eq 'free'
      end
    end

    context 'with task, that have been updated in last N days' do
      it 'live status active' do
        task = Task.new
        task.assign(User.last)
        task.updated_at = Time.now - 1.day
        task.save

        Task.unassign_tasks(60)

        expect(Task.last.status).to eq 'active'
      end
    end

    context 'with tasks, thet have status commited' do
      it 'live without changes' do
        task = Task.create(user: User.create, status: :commited)
        task.updated_at = '2009-08-15 18:05:44'
        task.save

        Task.unassign_tasks(60)

        expect(Task.last.status).to eq('commited')
      end
    end
  end

  describe '.first_free' do
    it 'do not return resticted tasks' do
      task1 = Task.create(stage: 2)
      task2 = Task.create(stage: 2)
      user = User.create
      Restriction.create(user: user, task: task1)

      expect(Task.first_free(2, user)).to eq(task2)
    end
  end
end
