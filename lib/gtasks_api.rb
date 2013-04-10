#!/usr/bin/env ruby

require 'google/api_client'

class GTasksAPI
	def initialize
		@client = Google::APIClient.new(application_name: "GTDWGT", application_version: 1)
		@client.authorization.client_id = GT_CLIENT_ID
		@client.authorization.client_secret = GT_CLIENT_SECRET
		@client.authorization.redirect_uri = GT_REDIRECT_URI
		@client.authorization.scope = 'https://www.googleapis.com/auth/tasks'

		@gtasks = @client.discovered_api('tasks')
	end

	def redirect_uri
		@client.authorization.authorization_uri.to_s
	end

	# def fetch_access_token
	# 	@client.authorization.fetch_access_token!
	# end

	# def task_lists
	# 	# Get task lists
	# 	result = @lient.execute(:api_method => @gtasks.tasklists.list)
	# 	# Lists are in result.data.items
	# 	@lists = result.data.items
	# 	@lists
	# end

	# def tasks
	# 	# Get task lists if we haven't already
	# 	# TODO: Should task lists be re-fetched every time?
	# 	task_lists if @lists.nil?
	# 	@tasks = Hash.new
	# 	@lists.each do |list|
	# 		result = @client.execute(:api_method => @gtasks.tasks.list, parameters: { 'tasklist' => list.id })
	# 		@tasks[list] = result.data.items
	# 	end
	# end
end