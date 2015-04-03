class TagsController < ApplicationController

	# We're an API, no need for tokens
	skip_before_filter :verify_authenticity_token


	def index
		# Noop
		# Possible entity_type values: video, gif, image
		# Possible entity_id values: anything
		# Possible tags values: anything
	end

	def find(entity_type, entity_id)
		response = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
	end

	def create
		# Accept POST data for a new object

		# Search for the record first, if it exists then delete it
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		if entity.present?
			entity.destroy
		end

		# Create a new entry
		new_entity = { :entity_type => params[:entity_type], :entity_id => params[:entity_id], :tags => params[:tags] }
		entity = Tag.new(new_entity)
		entity.save

		# Redirect to the new entity
		redirect_to :action => "show", :entity_type => new_entity[:entity_type], :entity_id => new_entity[:entity_id]
	end


	def show
		# Fetch the entity that matches the entered parameters
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		render :json => entity
	end


	def delete
		# Delete the entity that matches the entered parameters
		entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
		entity.destroy
		render :plain => entity
	end


end
