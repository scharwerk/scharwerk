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
    tasks_count(result)
    render json: result
  end

  def tasks_count(result)
    Task.group(:status, :stage).count.each do |ss, count|
      status = Task.statuses.key(ss[0])
      stage = Task.stages.key(ss[1])
      result[stage][status] = count
      result[stage]['total'] += count
    end
  end

  def users
    result = { 
      top: User.stats_users,
      users: User.all.count
    }

    result[:current] = current_user.total_pages_done if current_user

    # calculate total number of finished pages
    result[:total] = result[:top].inject(0) { |a, e| a + e[:done] }

    render json: result
  end
end
