class TagsController < ApplicationController

	# We're an API, no need for tokens
	skip_before_filter :verify_authenticity_token


	def index
		# Noop
		# Possible entity_type values: video, gif, image
		# Possible entity_id values: anything
		# Possible tags values: anything
	end


	def create
		# Accept POST data for a new object

		# Search for the entity first, and if it exists then delete it
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		if entity.present?
			entity.destroy(entity[0][:id])
		end

		# Create a new entity
		begin
			new_entity = { :entity_type => params[:entity_type], :entity_id => params[:entity_id], :tags => params[:tags] }
			entity = Tag.new(new_entity)
			entity.save
		rescue ActiveRecord::ActiveRecordError
			# If there was an error return 500
			render :nothing => true, :status => :internal_server_error
		end
		# If there was no error return 200
		render :nothing => true, :status => :ok
	end


	def show
		# Fetch the entity that matches the entered parameters
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		render :json => entity
	end


	def delete
		# Delete the entity that matches the entered parameters
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		if entity.present?
			entity.destroy(entity[0][:id])
			# Return a 200 status code
			render :nothing => true, :status => :ok
		else
			# Return a 204 error code
			render :nothing => true, :status => :no_content
		end
	end


end
