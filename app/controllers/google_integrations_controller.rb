require 'gtasks_api'

class GoogleIntegrationsController < ApplicationController
	def request_authorization
		# Create new GTasks API object 'gtapi' using GoogleIntegrationsHelper
		gtapi = GTasksAPI.new
		redirect_to gtapi.redirect_uri
	end

	def check_authorization
		# User did not allow access
		if params[:error] == 'access_denied'
			flash[:notice] = "You can't manage your tasks until you link to a Google account!"
		# Allowed access, authorization code is in params
		elsif params[:code]
			gtapi = GTasksAPI.new
			# Set authorization code from params
			current_user.authorization_code = params[:code]
			# Authorize
			current_user.access_token = gtapi.authorize(current_user.authorization_code)
			
			# Debug info
			# puts "*************************************"
			# gtapi.fetch_latest_everything
			# gtapi.tasks.each_pair do |list, tasks|
			# 	puts list.title
			# 	tasks.each do |task|
			# 		puts "  #{task.title}"
			# 	end
			# 	puts
			# end
			# puts "*************************************"

			current_user.g_email = gtapi.user_info.email
			current_user.g_name = gtapi.user_info.name
			current_user.save(:validate => false)
			flash[:success] = "Successfully linked to #{current_user.g_email} (#{current_user.g_name})"
			sign_in current_user
		# Not sure what other errors could occur
		else
			flash[:notice] = "An error occurred"
			if params[:error]
				flash[:notice] += ": #{params[:error]}"
			end
		end
		# Redirect
		redirect_to current_user
	end
end
