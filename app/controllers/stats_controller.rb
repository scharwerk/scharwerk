# add top level class documentation
class StatsController < ApplicationController
  # Rails black magic
  # Should return hash of hashes of tasks stats
  # ex {
  #   "first_proof" : {"active": 10, "completed": 90},
  #   "second_proof" : {"active": 0, "completed": 100}
  # }
  def tasks
    result = {}
    Task.stages.each { |s, _| result[s] = {'total' => 0} }
    Task.group(:status, :stage).count.each do |ss, count|
      status = Task.statuses.key(ss[0])
      stage = Task.stages.key(ss[1])
      result[stage][status] = count
      result[stage]['total'] += count
    end
    respond_with result
  end
end
