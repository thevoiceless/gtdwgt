# This helper is used so that a single GTasksAPI object can be used across all actions in the GoogleIntegrationsController
# TODO: Investigate other (possibly better) options:
# - Create a new GTasksAPI object in every action, and set the authorization code if it exists
# - Make GTasksAPI a singleton
# - Store in session (insecure?)
module GoogleIntegrationsHelper
end
