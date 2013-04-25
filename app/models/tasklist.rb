require 'gtasks_api'

class TaskList
	attr_accessor :id
	attr_accessor :title
	attr_accessor :updated
	attr_accessor :tasks

	def initialize(list, tasks)
		@id = list.id
		@title = list.title
		@updated = list.updated
		@tasks = tasks
	end

	def self.get_latest_for(user)
		gtapi = GTasksAPI.new(user.authorization_code, user.access_token)
		lists = Array.new
		gtapi.fetch_latest_task_lists.each do |list|
			tasks = Array.new
			gtapi.tasks_for(list).each do |task|
				tasks << Task.new_from_task(task)
			end
			lists << TaskList.new(list, tasks)
		end
		lists
	end

	def self.add_task_to_list(user, list_id, task_resource)
		gtapi = GTasksAPI.new(user.authorization_code, user.access_token)
		puts "List id in TaskList: #{list_id}"
		puts "Task resource in TaskList: #{task_resource}"
		gtapi.add_task_to_list(list_id, task_resource)
	end
end