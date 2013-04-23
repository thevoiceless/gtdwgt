require 'tasklist'

class TaskListsController < ApplicationController
	def index
		@task_lists = TaskList.get_latest_for(current_user)
	end

	def new_task
		@task_lists = TaskList.get_latest_for(current_user)
	end

	def add_task_to_list
		@task = Task.new(params[:task])
	end
end
