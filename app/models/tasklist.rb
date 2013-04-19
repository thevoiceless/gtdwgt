require 'gtasks_api'

class TaskList
	def initialize(tasks)
		@tasks = tasks
	end

	def self.get_latest_for(user)
		lists = Array.new
		@gtapi = GTasksAPI.new(user.authorization_code, user.access_token)
		@gtapi.tasks.each_pair do |list, tasks|
			t = Array.new
			tasks.each do |task|
				t << Task.new(task)
			end
			lists << TaskList.new(t)
		end
		lists
	end
end