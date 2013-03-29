module SessionsHelper
	def sign_in(user)
		# "Permanent" = Expires 20 years from now
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def sign_out
		self.current_user = nil
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

	# Is there a user signed in?
	def signed_in?
		!current_user.nil?
	end
end
