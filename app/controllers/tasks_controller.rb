# current user task
class TasksController < ApplicationController
  before_filter :authenticate_user!

  def show
    is_task_missing && return
    respond_with current_user.active_task
  end

  # assign free task to user
  def create
    if current_user.active_task
      render text: 'already assiged', status: :bad_request
      return
    end

    stage = params['stage']
    task = Task.where(stage: Task.stages[stage]).free.first
    task.assign(current_user)
    respond_with task
  end

  # mark task as completed
  def update
    task_missing && return
  end

  # free task from user
  def destroy
    task_missing && return
    current_user.active_task.release
    render text: 'released', status: :ok
  end

  def commit
    Task.commit_all
  end

  private

  def task_missing
    current_user.active_task && return

    render text: 'not found', status: :not_found
    true
  end
end
