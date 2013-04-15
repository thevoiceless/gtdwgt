class ApplicationController < ActionController::Base
  protect_from_forgery

  # All helpers are available in views by default, but not in the controllers
  # To use the methods from helpers in both places, include them explicitly
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
  	sign_out
  	super
  end
end
