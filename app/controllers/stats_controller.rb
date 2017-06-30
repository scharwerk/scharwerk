# add top level class documentation
class StatsController < ApplicationController
  # Rails black magic
  # Should return hash of hashes of tasks stats
  # ex {
  #   "first_proof" : {"active": 10, "completed": 90},
  #   "second_proof" : {"active": 0, "completed": 100}
  # }
  def tasks
    result = Task.stages.map { |s, _| [s, { 'total' => 0 }] }.to_h
    Task.group(:status, :stage).count.each do |ss, count|
      status = Task.statuses.key(ss[0])
      stage = Task.stages.key(ss[1])
      result[stage][status] = count
      result[stage]['total'] += count
    end
    respond_with result
  end

  def users
    result = { top: [], going: [] }

    User.all.each do |user|
      if user.tasks_done > 0
        result[:top] << { name: user.name, tasks: user.tasks_done }
      elsif user.active_task
        result[:going] << { name: user.name, pages: user.pages_done }
      end
    end
    result[:top].sort_by! { |k| -k[:tasks] }
    result[:users] = User.all.count

    result[:current] = current_user.tasks_done if current_user

    # calculate total number of finished tasks
    result[:total] = result[:top].inject(0) { |a, e| a + e[:tasks] }

    respond_with result
  end
end
