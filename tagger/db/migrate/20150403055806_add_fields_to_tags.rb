class AddFieldsToTags < ActiveRecord::Migration
  def change
	change_table :tags do |t|
    	t.string	:entity_type
    	t.string	:entity_id
    	t.text	:tags
	end
	add_index :tags, :entity_id
	add_index :tags, :entity_type
  end
end
