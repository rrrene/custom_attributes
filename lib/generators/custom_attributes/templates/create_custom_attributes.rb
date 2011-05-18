class CreateCustomAttributes < ActiveRecord::Migration
  def self.up
    create_table :custom_attributes do |t|
      t.string :name
      t.string :owner
      t.string :scope_type
      t.string :scope_id
      t.timestamps
    end
    add_index :custom_attributes, [:scope_type, :scope_id]
    
    create_table :custom_attribute_values do |t|
      t.integer :custom_attribute_id
      t.string :owner_id
      t.string :value
      t.timestamps
    end
    add_index :custom_attribute_values, :custom_attribute_id
  end
  
  def self.down
    remove_index :custom_attributes, [:item_type, :item_id]
    drop_table :custom_attributes
    remove_index :custom_attribute_values, [:custom_attribute_id]
    drop_table :custom_attribute_values
  end
end