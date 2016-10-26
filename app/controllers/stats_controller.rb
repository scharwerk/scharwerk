# add top level class documentation
class StatsController < ApplicationController
  def tasks
    stage = params['stage']
    respond_with Task.where(stage: Task.stages[stage]).group(:status).count
  end
end
