# add top-level class documentation
class PagesController < ApplicationController
  before_filter :authenticate_user!

  def show
    render json: current_user.active_task.pages.find(params[:id])
  end

  def update
    page = current_user.active_task.pages.find(params[:id])
    status = params[:done] ? 'done' : 'free'
    page.update(status: status)
    page.text = params[text]

    render json: current_user.active_task
  end
end
