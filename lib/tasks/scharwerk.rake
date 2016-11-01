namespace :sharwerk do
  desc "The task do something important"
  task :good_task, [:argument] => :environment do |t, args|
    puts args[:argument]
  end
end

# call this task in console 
# rake sharwer:good_task[<the_argument_value>]
# more information http://railscasts.com/episodes/66-custom-rake-tasks


