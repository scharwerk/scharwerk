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

  desc 'Send fb notifications'
  task :notify_fb, [:app_id,
                    :app_secret,
                    :user_id] => :environment do |_t, args|

    auth = FbGraph2::Auth.new(args[:app_id], args[:app_secret])
    params = { access_token: args[:app_id] ? auth.access_token!.to_s : nil }

    User.all.each do |user|
      # only for user_id if set
      next if args[:user_id] && user.facebook_id != args[:user_id]

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
end
