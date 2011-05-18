module CustomAttributes
  module Model
    module ClassMethods
      def has_custom_attributes
        self.__send__ :include, CustomAttributes::HasCustomAttributes
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
  
  module HasCustomAttributes
    module ClassMethods
      def custom_attributes
        @custom_attributes ||= {}
        @custom_attributes[::CustomAttributes.scope || :no_scope] ||= begin
          arel = ::CustomAttribute.where(:owner => self.to_s)
          if scope = ::CustomAttributes.scope
            arel = arel.where(:scope_type => scope.class.to_s, :scope_id => scope.id)
          else
            arel = arel.where('scope_type IS NULL AND scope_id IS NULL')
          end
          arel
        end
      end
      
      def add_custom_attribute(value_or_array)
        case value_or_array
          when ::CustomAttribute
            value_or_array.owner = self.to_s
            value_or_array.save
          when Array
            opts = {:scope => ::CustomAttributes.scope}
            opts.merge!(value_or_array.pop) if value_or_array.last.is_a?(Hash)
            value_or_array.each do |name|
              add_custom_attribute ::CustomAttribute.new(opts.merge(:name => name))
            end
          when String, Symbol
            add_custom_attribute [value_or_array]
          else
            raise "Uexpected values for custom_attributes <<: #{value_or_array.inspect}"
        end
      end
    end

    module InstanceMethods
      def [](name)
        custom_attributes[name] || super
      end
      
      def []=(name, value)
        if custom_attribute_names.include?(name)
          custom_attributes[name] = value
        else
          super
        end
      end
      
      def attributes=(hash)
        custom_attribute_names.each do |name|
          if hash.keys.include?(name)
            custom_attributes[name] = hash.delete(name)
          end
        end
      end
      
      def attributes
        super.merge custom_attributes
      end
      
      def custom_attributes
        @custom_attributes ||= {}
        @custom_attributes[::CustomAttributes.scope || :no_scope] ||= begin
          all_attributes = self.class.custom_attributes
          all_attributes.inject({}) do |attribs, custom_attrib|
            # FIXME: should NOT make a separate request to the db for each value
            attribs[custom_attrib.name] = read_custom_attribute(custom_attrib.name)
            attribs
          end
        end
      end
      
      def custom_attribute_names
        self.class.custom_attributes.map(&:name)
      end
    
      def method_missing(meth, *args, &blk)
        name = meth.to_s.gsub(/\=$/, '')
        if custom_attribute_names.include?(name)
          if meth =~ /\=$/
            self[name] = args.first
          else
            self[name] || read_custom_attribute(name)
          end
        else
          super
        end
      end
      
      private
      
      def attribute_values(name)
        custom_attribute = self.class.custom_attributes.where(:name => name).first
        custom_attribute.custom_attribute_values
      end
      
      def read_custom_attribute(name)
        attribute_values(name).where(:owner_id => self.id).first.try(:value)
      end

      def write_custom_attribute(name, value)
        values = attribute_values(name)
        existing_value = values.where(:owner_id => self.id).first
        if existing_value
          existing_value.update_attribute(:value, value)
        else
          values.create(:owner_id => self.id, :value => value)
        end
      end
      
      def write_custom_attributes_from_hash
        custom_attributes.each do |name, value|
          write_custom_attribute(name, value)
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.__send__ :include, InstanceMethods
      receiver.after_save :write_custom_attributes_from_hash
    end
  end
end