class Task
	attr_accessor :title
	attr_accessor :notes
	attr_accessor :updated
	attr_accessor :completed
	attr_accessor :due_date
	attr_accessor :completed_date

	# Google supposedly requires a valid RFC3339 timestamp
	# However, they will not accept it unless the time zone is written as '.000Z'
	# This does not appear to match the RFC3339 format for UTC timestamps
	# As a result, this format string must be passed to DateTime.strftime instead
	GOOGLE_RFC3339_FORMAT = '%Y-%m-%dT%H:%M:%S.000Z'
	# More readable date format
	# {day of week}, {month} {day of month}, {year}
	PRETTY_DATE_FORMAT = '%A, %B %e, %Y'

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
			representation['status'] = @completed ? "completed" : "needsAction"
		end
		representation['due'] = "#{@due_date}" if @due_date
		representation['completed'] = "#{@completed_date}" if @completed_date

		# Convert
		#   \" to '
		# and
		#   => to :
		# to mach the required resource representation
		representation.to_s.gsub(/\"/, '\'').gsub(/\=>/, ': ')
	end

	def pretty_due_date
		DateTime.parse(@due_date.to_s).strftime(PRETTY_DATE_FORMAT)
	end

	def status
		status = @completed ? "Done" : "Incomplete"
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
		t.due_date = DateTime.strptime(params[:due_date], PRETTY_DATE_FORMAT).strftime(GOOGLE_RFC3339_FORMAT)
		t.updated = DateTime.now.strftime(GOOGLE_RFC3339_FORMAT)

		t
	end
end