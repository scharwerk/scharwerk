# Usefull scripts for console

User.all.each do |u|
  g = JSON.parse(u.facebook_data)['gender']
  puts "ok, %s, %s" % [u.total_pages_done, g]
  [u.total_pages_done, g]
end

# count changes by task
totals = Hash.new(0)
Task.markup.commited.each { |t| totals[t.line_diff_count] += 1 }
