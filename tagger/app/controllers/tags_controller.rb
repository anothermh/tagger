class TagsController < ApplicationController

	# We're an API, no need for tokens
	skip_before_filter :verify_authenticity_token


	def index
		# Noop
	end


	def create
		# Accept POST data for a new object
	end


	def show
		# Fetch the objects that match the entered parameters
	end


	def delete
		# Delete the objects that match the entered parameters
	end


end
