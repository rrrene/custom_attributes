# CustomAttributes

require 'custom_attributes/custom_attribute'
require 'custom_attributes/custom_attribute_value'
require 'custom_attributes/controller'
require 'custom_attributes/has_custom_attributes'
require 'custom_attributes/version'

module CustomAttributes
  class << self
    attr_accessor :scope
    attr_accessor :scope_method
  end
end

ActiveSupport.on_load(:active_record) do
  include CustomAttributes::Model
end

ActiveSupport.on_load(:action_controller) do
  include CustomAttributes::Controller
end