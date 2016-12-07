namespace :sharwerk do
  desc "The task do something important"
  task :good_task, [:argument] => :environment do |t, args|
    puts args[:argument]
  end

  desc "Create all tasks and pages from texts"
  task :create_tasks, [:scans_folder_path, :texts_folder_path, :stage] => :environment do |t, args|

    part_pages = Page.create_pages(args[:scans_folder_path], args[:texts_folder_path])

    part = Task.parse_part(args[:scans_folder_path])
    Task.generate_tasks(part_pages, part, args[:stage])
  end
  # call this task in console
  # bundle exec rake sharwerk:create_tasks['public/scharwerk_data/scans/3.2','public/scharwerk_data/texts/3.2','first_proof']
  # more information http://railscasts.com/episodes/66-custom-rake-tasks
end
