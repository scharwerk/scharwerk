require 'json'

# add top-level class documentation
class TasksController < ApplicationController
  def stats
    stage = params['stage']
    respond_with Task.where(stage: Task.stages[stage]).group(:status).count
  end
end
