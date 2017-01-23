namespace :scharwerk do
  desc 'Create all tasks and pages from texts'
  task :generate_tasks, [:pattern,
                         :stage,
                         :part,
                         :pages_per_task] => :environment do |_t, args|
    part_pages = Page.create_pages(args[:pattern])

    tasks = Task.generate_tasks(part_pages,
                                args[:part],
                                args[:stage],
                                args[:pages_per_task].to_i)
    tasks.each do |task|
      puts 'Task #' + task.id.to_s
      task.pages.each do |page|
        puts "\t Page #" + page.id.to_s + ' ' + page.path
      end
    end
  end
end
