require 'tasklist'

class TaskListsController < ApplicationController
	def index
		@task_lists = TaskList.get_latest_for(current_user)
	end

	def new_task
		@task_lists = TaskList.get_latest_for(current_user)
	end

	def add_task_to_list
		@task = Task.new_from_params(params)
		puts "\n********************"
		puts "Params: #{params}"
		puts "List ID: #{params[:list][:list_id]}" if params[:list]
		puts @task.resource_representation
		puts "********************"
		TaskList.add_task_to_list(current_user, params[:list][:list_id], @task.resource_representation)
		redirect_to tasks_path
	end
end
