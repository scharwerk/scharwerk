require 'net/http'

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

  desc 'Create tasks for second proof'
  task :generate_tasks_2, [:pattern,
                           :part] => :environment do |_t, args|
    pages = Page.create_pages(args[:pattern])

    pages.each do |page|
      task = Task.generate_task2(page, args[:part])
      puts 'Task #' + task.id.to_s
      puts "\t Page #" + page.id.to_s + ' ' + page.path
    end
  end

  desc 'Create tasks for markup'
  task :generate_tasks_3, [:pattern,
                           :part] => :environment do |_t, args|
    TaskManager.generate_task3(args[:pattern],  args[:part]).each do |t|
      puts 'Task #' + t.id.to_s + ' ' + t.path
    end
  end

  desc 'Send fb notifications'
  task :notify_fb, [:app_id,
                    :app_secret,
                    :user_id] => :environment do |_t, args|

    auth = FbGraph2::Auth.new(args[:app_id], args[:app_secret])
    params = { access_token: args[:app_id] ? auth.access_token!.to_s : nil }

    User.all.each do |user|
      # only for user_id if set
      next if args[:user_id] && user.facebook_id != args[:user_id]

      # skip empty messages
      next if user.notification_message.blank?

      params[:ref], msg = user.notification_message
      params[:template] = format('@[%s], %s', user.facebook_id, msg)
      puts params

      # if no key continue
      next unless params[:access_token]

      uri = URI.parse('https://graph.facebook.com')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      path = format('/v2.8/%s/notifications?%s',
                    user.facebook_id,
                    URI.encode_www_form(params))

      res = https.request(Net::HTTP::Post.new(path))
      puts "Response: #{res.code} #{res.body}"
    end
  end

  desc 'Unassign tasks thet havent been modified for N days'
  task :unassign_tasks, [:days_not_updated] => :environment do |_t, args|
    p Task.unassign_tasks(args[:days_not_updated].to_i)
  end
end
