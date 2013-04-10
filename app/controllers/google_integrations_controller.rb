class GoogleIntegrationsController < ApplicationController
	require 'gtasks_api'

	def request_authorization
		@gtapi = GTasksAPI.new

		redirect_to @gtapi.redirect_uri
	end
end
