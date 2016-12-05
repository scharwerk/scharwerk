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
  task :create_pages, [:scans_folder_path, :texts_folder_path] => :environment do |t, args|
    Dir.foreach(args[:scans_folder_path]) do |item|
      # 'public/scharwerk_data/scans/3.2'
      next if item == '.' || item == '..'
      page = Page.new
      page.path = item
      number = item.delete('.jpg')
      page.text = ''

      File.open(args[:texts_folder_path] + "/#{number}.txt", 'r') do |f|
        # public/scharwerk_data/texts/3.2
        f.each_line {|line| page.text += line.gsub("\u0000", '')}
      end

      page.save
    end
  end
  desc "Create all tasks and pages from texts"
  task :create_tasks, [:scans_folder_path, :texts_folder_path, :stage] => :environment do |t, args|
    # create all pages from scans in dir
    part_pages = []
    Dir.foreach(args[:scans_folder_path]) do |item|
      # 'public/scharwerk_data/scans/3.2'
      next if item == '.' || item == '..'
      page = Page.new
      page.path = item
      number = item.delete('.jpg')
      page.text = ''

      File.open(args[:texts_folder_path] + "/#{number}.txt", 'r') do |f|
        # public/scharwerk_data/texts/3.2
        f.each_line {|line| page.text += line.gsub("\u0000", '')}
      end
      page.save
      part_pages.push(page)
    end
    #create one task from pages
    task = Task.new
    task.stage = args[:stage]
    task.save
    #parse part number here
    20.times do |i|
      part_pages[i].update(task_id: task.id)
    end
  end
end

# call this task in console
# rake sharwer:good_task[<the_argument_value>]
# more information http://railscasts.com/episodes/66-custom-rake-tasks
