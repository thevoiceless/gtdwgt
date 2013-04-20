class Task
	attr_accessor :title
	attr_accessor :notes
	attr_accessor :updated
	attr_accessor :completed
	attr_accessor :due_date
	attr_accessor :completed_date

	def initialize(task)
		@title = task.title
		@notes = task.notes
		@updated = task.updated
		@completed = true ? task.status == 'completed' : false
		@due_date = task.due ? task.due : nil
		@completed_date = task.completed ? task.completed : nil
	end
end