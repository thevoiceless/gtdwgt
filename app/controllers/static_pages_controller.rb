class StaticPagesController < ApplicationController
  def home
  	@joke = Joke.find(:one, :from => "/jokes/random")
  end
end
