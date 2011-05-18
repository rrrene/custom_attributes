# CustomAttributes

## Introduction

CustomAttributes allows you to add custom attributes to ActiveRecord objects, optionally scoped by another model (e.g. users or accounts).

## Usage

Define that a model has custom attributes:

    class Contact < ActiveRecord::Base
      has_custom_attributes
    end
    
Now, add custom attributes to the model:
    
    Contact.add_custom_attribute :internal_id
    Contact.add_custom_attribute "internal_id"
    Contact.add_custom_attribute [:internal_id, :nickname]

Use the new custom attributes like normal ones:

    c = Contact.new
    c.internal_id = "ABC-123"
    c.nickname = "Dude"
    c.save
    
Add scope by defining which controller method returns it:
    
    ::CustomAttributes.scope_method = :current_user

Or set the scope object directly:

    ::CustomAttributes.scope = User.first

Or override the controller method that returns the scope:
    
    class ApplicationController < ActionController::Base
      def custom_attribute_scope
        # scope determination
        if current_user.can?(:customize, resource)
          current_user
        end
      end
    end

    
## Inspiration

has-magic-columns: http://code.google.com/p/has-magic-columns/

## License

Copyright (c) 2011 René Föhring, released under the MIT license
