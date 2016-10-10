require 'json'

# add top-level class documentation
class TasksController < ApplicationController
  def stats
    stage = params['stage']
    respond_with Task.where(stage: stage).group(:status).count
  end
end
