class GoogleIntegrationsController < ApplicationController
	def request_authorization
		# Create new GTasks API object 'gtapi' using GoogleIntegrationsHelper
		create_new_gt_api
		redirect_to gtapi.redirect_uri
	end

	def check_authorization
		# User did not allow access
		if params[:error] == 'access_denied'
			flash[:notice] = "You can't manage your tasks until you link to a Google account!"
		# Allowed access, authorization code is in params
		elsif params[:code]
			# Get authorization code from params
			current_user.authorization_code = params[:code]
			# Assign to gtapi and authorize
			gtapi.authorize(params[:code])
			# Fetch user info and tasks
			gtapi.fetch_info_and_tasks
			flash[:success] = "Successfully linked to #{gtapi.user_info.email} (#{gtapi.user_info.name})"
			# Debug info
			puts "*************************************"
			gtapi.tasks.each_pair do |list, tasks|
				puts list.title
				tasks.each do |task|
					puts "  #{task.title}"
				end
				puts
			end

			current_user.linked_email = gtapi.user_info.email
			current_user.save(:validate => false)
			sign_in current_user

			puts "Current user is #{current_user}"
			puts "Their auth code is #{current_user.authorization_code} (should be #{params[:code]})"
			puts "Their linked email is #{current_user.linked_email} (should be #{gtapi.user_info.email})"
			puts "*************************************"
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
