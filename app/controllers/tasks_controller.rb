# current user task
class TasksController < ApplicationController
  before_filter :authenticate_user!

  def show
    !current_user.active_task && (render text: 'not found', status: :not_found) && return
    respond_with current_user.active_task
  end

  # assign free task to user
  def create
    current_user.active_task && (render text: 'already assiged', status: :bad_request) && return

    stage = params['stage']
    task = Task.where(stage: Task.stages[stage]).free.first
    task.assign(current_user)
    respond_with task
  end

  # mark task as completed
  def update
    !current_user.active_task && (render text: 'not found', status: :not_found) && return
  end

  # free task from user
  def destroy
    !current_user.active_task && (render text: 'already assiged',status: :not_found) && return
    current_user.active_task.release
    render text: 'released', status: :ok
  end
end
