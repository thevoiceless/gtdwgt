module SessionsHelper
	def sign_in(user)
		# "Permanent" = Expires 20 years from now
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
		if current_user.access_token
			puts "\n************* USER HAS TOKEN: #{current_user.access_token} *********************"
			gtapi.set_access_token(current_user.access_token)
		end
	end

	def sign_out
		self.current_user = nil
		gtapi = nil
		cookies.delete(:remember_token)
	end

	# Must define assignment function for current_user, I have no idea why
	def current_user=(user)
		@current_user = user
	end

	def current_user
		# Calls find_by_remember_token the first time current_user is called
		# On subsequent invocations returns @current_user without hitting the database
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	# Check if the given user is the current one
	def current_user?(user)
		user == current_user
	end

	# Check if there is a user signed in
	def signed_in?
		!current_user.nil?
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end
