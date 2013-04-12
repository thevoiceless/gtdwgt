# This helper is used so that a single GTasksAPI object can be used across all actions in the GoogleIntegrationsController
# TODO: Investigate other (possibly better) options:
# - Create a new GTasksAPI object in every action, and set the authorization code if it exists
# - Make GTasksAPI a singleton
# - Store in session (insecure?)
module GoogleIntegrationsHelper
	require 'gtasks_api'

	# Create a new GTasks API object
	def create_new_gt_api
		self.gtapi = GTasksAPI.new
	end

	# Operator to assign self.gtapi (above)
	def gtapi=(apiobj)
		@gtapi = apiobj
	end

	# Return the GTasks API object
	def gtapi
		@gtapi ||= GTasksAPI.new
	end
end
