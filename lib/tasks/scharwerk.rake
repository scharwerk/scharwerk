namespace :sharwerk do
  desc "The task do something important"
  task :good_task, [:argument] => :environment do |t, args|
    puts args[:argument]
  end

  desc "Create page from scan and text"
  task :create_page, [:scan_path, :text_path] => :environment do |t, args| 
    page = Page.new
    page.path = args[:scan_path]
    # 'public/scharwerk_data/scans/3.2/8.jpg'
    page.text = '' 
    File.open(args[:text_path], 'r') do |f|
      # 'public/scharwerk_data/texts/3.2/8.txt'
      f.each_line {|line| page.text += line.gsub("\u0000", '')} 
    end
    page.save
  end

  desc "Create all pages from scans and texts"
  task :create_pages => :environment do
    Dir.foreach('public/scharwerk_data/scans/3.2') do |item|
      next if item == '.' || item == '..'
      puts item
    end
  end
end

# call this task in console 
# rake sharwer:good_task[<the_argument_value>]
# more information http://railscasts.com/episodes/66-custom-rake-tasks


