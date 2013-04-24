#!/usr/bin/env ruby

require 'google/api_client'

class GTasksAPI
	# Initiate the API connection
	def initialize(authcode=nil, token=nil)
		@client = Google::APIClient.new(application_name: "GTDWGT", application_version: 1)
		# Constants from config/initializers/integration.rb
		@client.authorization.client_id = ENV['GT_CLIENT_ID'] || GT_CLIENT_ID
		@client.authorization.client_secret = ENV['GT_CLIENT_SECRET'] || GT_CLIENT_SECRET
		@client.authorization.redirect_uri = ENV['GT_REDIRECT_URI_PRODUCTION'] || GT_REDIRECT_URI
		# Will request user information and tasks
		@client.authorization.scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/tasks'

		@gtasks = @client.discovered_api('tasks')
		@info = @client.discovered_api('oauth2')

		if authcode and token
			@client.authorization.code = authcode
			@client.authorization.access_token = token
		end

		@tasks = Hash.new
	end

	# Return the Google authorization URI
	def redirect_uri
		@client.authorization.authorization_uri.to_s
	end

	# Attempt to authorize using the given authorization code, return access token
	# TODO: Determine what errors this can throw
	def authorize(authcode)
		@client.authorization.code = authcode
		@client.authorization.fetch_access_token!
		@client.authorization.access_token
	end

	def authorization_code=(code)
		@client.authorization.code = code
	end

	def authorization_code
		@client.authorization.code
	end

	def access_token=(token)
		@client.authorization.access_token = token
	end

	def access_token
		@client.authorization.access_token
	end

	# Return current user info, fetch if it does not exist
	def user_info
		@user_info ||= fetch_latest_user_info
	end

	# Fetch and return latest user info
	def fetch_latest_user_info
		@user_info = @client.execute(api_method: @info.userinfo.get).data
	end

	# Return current task lists, fetch if it does not exist
	def task_lists
		@task_lists ||= fetch_latest_task_lists
	end

	# Fetch and return latest task lists
	def fetch_latest_task_lists
		response = @client.execute(api_method: @gtasks.tasklists.list)
		puts "***************** ERROR FETCHING TASK LISTS *****************" if response.status != 200
		p response
		@task_lists = response.data.items
	end

	# Return the tasks for a list, fetch if it does not exist
	def tasks_for(list)
		@tasks[list] ||= fetch_latest_tasks_for(list)
	end

	# Fetch and return latest tasks for a list
	def fetch_latest_tasks_for(list)
		@tasks[list] = @client.execute(api_method: @gtasks.tasks.list, parameters: { 'tasklist' => list.id }).data.items
	end

	def add_task_to_list(list_id, task_resource)
		puts "**************** ADDING TASK TO LIST ********************"
		puts "List ID:"
		list_id
		puts "Task resource:"
		task_resource
		response = @client.execute(api_method: @gtasks.tasks.insert, parameters: { 'tasklist' => list_id }, headers: { 'Content-Type' => 'application/json' }, body: task_resource)
		puts "Response: #{response.status}"
		if response.status != 200
			puts "***************** ERROR ADDING TASK *****************"
			p response
		end
	end

	####################################################
	# Not sure if the functions below are still needed #
	####################################################

	# Fetch user information, task lists, and tasks
	def fetch_latest_everything
		@user_info = @client.execute(api_method: @info.userinfo.get).data
		@task_lists = @client.execute(api_method: @gtasks.tasklists.list).data.items
		@tasks = Hash.new
		@task_lists.each do |list|
			@tasks[list] = @client.execute(api_method: @gtasks.tasks.list, parameters: { 'tasklist' => list.id }).data.items
		end
		return @user_info, @task_lists, @tasks
	end
end