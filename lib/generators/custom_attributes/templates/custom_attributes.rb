# Add scope by defining which controller method returns it:
# 
# ::CustomAttributes.scope_method = :current_user
# 
# Or set the scope object directly:
# 
# ::CustomAttributes.scope = User.first
# 
# Or override the controller method that returns the scope:
# 
# class ApplicationController < ActionController::Base
#   def custom_attribute_scope
#     # scope determination
#     if current_user.can?(:customize, resource)
#       current_user
#     end
#   end
# end
