# current user task
class TasksController < ApplicationController
  before_filter :authenticate_user!

  def show
    task_missing && return
    respond_with current_user.active_task
  end

  # assign free task to user
  def create
    if current_user.active_task
      render text: 'already assiged', status: :bad_request
      return
    end

    stage = Task.stages[params['stage']]
    task = Task.first_free(stage, current_user)
    task.assign(current_user)
    respond_with task, json: task
  end

  # mark task as completed
  def update
    task_missing && return
    if params['done']
      task = current_user.active_task
      task.finish
      GitWorker.perform_async(task.id)
    end
    return create if params['next']

    render json: { status: 'done' }, status: :ok
  end

  # free task from user
  def destroy
    task_missing && return
    task = current_user.active_task
    task.release
    return next_task(task) if params['next']

    render json: { status: 'released' }, status: :ok
  end

  private

  def next_task(old)
    task = Task.first_free(Task.stages[old.stage], current_user)
    task.assign(current_user)
    respond_with task, json: task
  end

  def task_missing
    current_user.active_task && return

    render json: { text: 'not found' }, status: :not_found
    true
  end
end
