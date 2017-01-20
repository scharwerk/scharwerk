namespace :scharwerk do
  desc 'Create all tasks and pages from texts'
  task :generate_tasks, [:pattern,
                         :stage,
                         :part,
                         :pages_per_task] => :environment do |_t, args|
    part_pages = Page.create_pages(args[:pattern])

    Task.generate_tasks(part_pages, args[:part],
                        args[:stage],
                        args[:pages_per_task].to_i)
  end
end
