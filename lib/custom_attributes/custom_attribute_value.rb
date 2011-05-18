class ::CustomAttributeValue < ActiveRecord::Base
  belongs_to :custom_attribute
  
  validates_presence_of :value
  validates_associated :custom_attribute
end
