class SessionsController < ApplicationController
	def new
	end

	def create
		# TODO: Only downcase the domain (see comments in user.rb)
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Sign in and redirect to the user's profile
			sign_in user
			redirect_back_or user
		else
			# Show an error message and display the signin form again
			# Using 'render' does not count as a request, so using the regular flash would persist one request longer than desired
			# Instead, use flash.now to display the error until the next request
			flash.now[:error] = 'Invalid email/password combination.'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
