class Task
	attr_accessor :title
	attr_accessor :notes
	attr_accessor :updated
	attr_accessor :completed
	attr_accessor :due_date
	attr_accessor :completed_date

	def initialize()
		@title = nil
		@notes = nil
		@updated = nil
		@completed = nil
		@due_date = nil
		@completed_date = nil
	end

	# https://developers.google.com/google-apps/tasks/v1/reference/tasks#resource
	def resource_representation
		representation = Hash.new

		representation['title'] = "#{@title}" if @title
		representation['notes'] = "#{@notes}" if @notes
		representation['updated'] = "#{@updated}" if @updated
		if !@completed.nil?
			representation['status'] = "completed" ? @completed : "needsAction"
		end
		representation['due'] = "#{@due_date}" if @due_date
		representation['completed'] = "#{@completed_date}" if @completed_date

		representation.to_s.gsub(/\"/, '\'').gsub(/\=>/, ': ')
	end

	def self.new_from_task(task)
		t = Task.new()
		t.title = task.title
		t.notes = task.notes
		t.updated = task.updated
		t.completed = true ? task.status == 'completed' : false
		t.due_date = task.due
		t.completed_date = task.completed

		t
	end

	def self.new_from_params(params)
		t = Task.new()
		t.title = params[:title]
		t.notes = params[:notes]

		t
	end
end