class ::CustomAttribute < ActiveRecord::Base
  belongs_to :scope, :polymorphic => true
  has_many :custom_attribute_values, :dependent => :destroy
  
  def owner
    attributes[:owner].try(:constantize)
  end
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:scope_type, :scope_id]
end
