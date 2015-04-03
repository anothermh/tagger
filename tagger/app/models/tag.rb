class Tag < ActiveRecord::Base
	serialize :tags, Array
end
