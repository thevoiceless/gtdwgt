class GoogleIntegrationsController < ApplicationController
	require 'gtasks_api'

	def request_authorization
		@gtapi = GTasksAPI.new

		redirect_to @gtapi.redirect_uri
	end

	def check_authorization
		if params[:error] == 'access_denied'
			flash[:notice] = "You can't manage your tasks until you link to a Google account!"
		elsif params[:code]
			flash[:success] = "Successfully linked accounts"
		else
			flash[:notice] = "An error occurred"
			if params[:error]
				flash[:notice] += ": #{params[:error]}"
			end
		end
		redirect_to root_path
	end
end
