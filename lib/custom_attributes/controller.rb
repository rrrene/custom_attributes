module CustomAttributes
  
  module Controller
    def self.included(base)
      base.before_filter :set_custom_attribute_scope
    end
    
    # override me
    def custom_attribute_scope
      if method_name = ::CustomAttributes.scope_method
       self.__send__(method_name)
      end
    end
    
    def set_custom_attribute_scope
      ::CustomAttributes.scope = custom_attribute_scope
    end
  end
  
end