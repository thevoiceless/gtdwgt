require 'tasklist'

class TaskListsController < ApplicationController
	def index
		@task_lists = TaskList.get_latest_for(current_user)
	end
end
