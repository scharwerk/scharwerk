class TasksController < ApplicationController
	def show
		render json: {task: 1}
	end
end
