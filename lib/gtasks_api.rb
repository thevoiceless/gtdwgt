#!/usr/bin/env ruby

require 'google/api_client'

class GTasksAPI
	def initialize
		@client = Google::APIClient.new(application_name: "GTDWGT", application_version: 1)
		@client.authorization.client_id = GT_CLIENT_ID
		@client.authorization.client_secret = GT_CLIENT_SECRET
		@client.authorization.redirect_uri = GT_REDIRECT_URI
		@client.authorization.scope = 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/tasks'

		@gtasks = @client.discovered_api('tasks')
		@info = @client.discovered_api('oauth2')
	end

	def redirect_uri
		@client.authorization.authorization_uri.to_s
	end

	def get_info_and_tasks
		@user_info = @client.execute(api_method: @info.userinfo.get).data
		@task_lists = @lient.execute(api_method: @gtasks.tasklists.list).data.items
		@tasks = Hash.new
		@task_lists.each do |list|
			@tasks[list] = @client.execute(api_method: @gtasks.tasks.list, parameters: { 'tasklist' => list.id }).data.items
		end
		return @user_info, @task_lists, @tasks
	end

	def user_info
		@user_info
	end

	def get_latest_user_info
		@user_info = @client.execute(api_method: @info.userinfo.get).data
		@user_info
	end

	def task_lists
		@task_lists
	end

	def get_latest_task_lists
		@task_lists = @lient.execute(api_method: @gtasks.tasklists.list).data.items
		@task_lists
	end

	def tasks
		 @tasks
	end

	def get_latest_tasks
		get_latest_task_lists
		@tasks = Hash.new
		@task_lists.each do |list|
			@tasks[list] = @client.execute(api_method: @gtasks.tasks.list, parameters: { 'tasklist' => list.id }).data.items
		end
	end
end