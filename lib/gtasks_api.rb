#!/usr/bin/env ruby

require 'google/api_client'

# # Initialize the client and Tasks API
client = Google::APIClient.new(application_name: "GTDWGT Test", application_version: 1)

# # Initialize OAuth 2.0 client    
client.authorization.client_id = '158458358460.apps.googleusercontent.com'
client.authorization.client_secret = 'IKvOgAZlsnBmSRc9t3p6IebY'
client.authorization.redirect_uri = 'http://localhost:3000/oauth2callback'
client.authorization.scope = 'https://www.googleapis.com/auth/tasks'

gtasks = client.discovered_api('tasks')

# Print authorization URI, must be manually opened in a browser
redirect_uri = client.authorization.authorization_uri
puts redirect_uri

# Copy and paste authorization code from URI in browser
client.authorization.code = gets.chomp
client.authorization.fetch_access_token!

# Get task lists
result = client.execute(:api_method => gtasks.tasklists.list)
# Lists are in result.data.items
lists = result.data.items
lists.each do |list|
	# Get tasks for each list
	result = client.execute(:api_method => gtasks.tasks.list, parameters: { 'tasklist' => list.id })
	tasks = result.data.items
	puts "#{list.title} - #{tasks.size} tasks"
	# Display each task and its status
	tasks.each do |task|
		puts "\t#{task.title} (#{task.status})"
	end
end