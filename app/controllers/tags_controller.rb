class TagsController < ApplicationController


	# We're an API, no need for tokens, but always set on a per-controller basis
	skip_before_filter :verify_authenticity_token


	def index
		# Noop
		# Possible entity_type values: video, gif, image
		# Possible entity_id values: anything, but I've used numbers
		# Possible tags values: anything, but I've used single words (no special characters)
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
			# If there was no error return 200
			render :nothing => true, :status => :ok
		rescue ActiveRecord::ActiveRecordError
			# If there was an error return 500
			render :nothing => true, :status => :internal_server_error
		end
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


	def stats

		# This is the worst thing we could possibly do, we just get every tag by pulling the entire table, 
		#  but hey, we're already serializing data to overload the fields because we're using sqlite, 
		#  and if we were doing this properly in something like mongo that eats JSON three meals a day 
		#  then we'd have a sane model that we could search, but this was supposed to only take two hours 
		#  and I'm a bit beyond that at this point so LET'S SHIP THIS CODE! WOE TO THOSE WHO RUN IT!
		# PS - I skipped case sensitivity

		# New array to store all the tags from the entire table
		tags = []

		# Clobber everything
		Tag.find_each do |tag|
			tag[:tags].each do |sub_tag|
				# Now we have an array with all the tags including duplicates
				tags << sub_tag
			end
		end

		# Create a new hash table with the counts like { 'cool': 2, 'awesome': 1 }, I straight lifted this from stackoverflow
		counts = Hash.new(0)
		tags.each do |tag|
			# counts is our hash that contains the actual count of each tag
			counts[tag] += 1
		end

		# If there are params POSTed here then search for just that one entity
		if params.has_key?(:entity_type) && params.has_key?(:entity_id)
			# I need to find this entity, find its tags, then find those tags in the hash
			entity = Tag.where("entity_type = ? AND entity_id = ?", params[:entity_type], params[:entity_id])
			if entity.present?
				# stats is the array containing the final info we're rendering
				stats = []
				entity[0][:tags].each do |x|
					stats << { "tag" => x, "count" => counts[x] }
				end
			end

			render :json => stats
		else
			# There were no params, so show stats about all tags

			# I need to return an array of hashes
			# [ {tag: NAME, count: COUNT}, {tag: NAME, count: COUNT} ]

			# Create a hash for each tag with its count
			stats = []
			counts.each do |count|
				hash = { "tag" => count[0], "count" => count[1] }
				stats << hash
			end

			render :json => stats
		end
	end


end