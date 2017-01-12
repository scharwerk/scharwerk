namespace :sharwerk do
  desc "The task do something important"
  task :good_task, [:argument] => :environment do |t, args|
    puts args[:argument]
  end

  desc "Create all tasks and pages from texts"
  task :create_tasks, [:scans_folder_path, :texts_folder_path, :stage, :part, :pages_per_task] => :environment do |t, args|

    part_pages = Page.create_pages(args[:scans_folder_path], args[:texts_folder_path])

    Task.generate_tasks(part_pages, args[:part], args[:stage], args[:pages_per_task].to_i)
  end
end

# call this task in console
# more information http://railscasts.com/episodes/66-custom-rake-tasks
#  bundle exec rake sharwerk:create_tasks['public/scans/franko.web','public/das-kapital/text/franko','test','franko',5]