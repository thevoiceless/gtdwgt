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
end