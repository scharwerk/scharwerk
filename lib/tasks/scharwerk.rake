namespace :sharwerk do
  desc "The task do something important"
  task :good_task, [:argument] => :environment do |t, args|
    puts args[:argument]
  end

  desc "Create page from scan and page"
  task :create_page => :environment do 
    page = Page.new
    page.path = 'public/scharwerk_data/scans/3.2/10.jpg'
    # page.text = File.read('public/scharwerk_data/texts/3.2/10.txt', 'r')
    page.text = '' 
    File.open('public/scharwerk_data/scans/3.2/1.jpg', 'r') do |f|
      f.each_line {|line| page.text += line.gsub("\u0000", '')} 
    end
    page.save
  end
end

# call this task in console 
# rake sharwer:good_task[<the_argument_value>]
# more information http://railscasts.com/episodes/66-custom-rake-tasks


