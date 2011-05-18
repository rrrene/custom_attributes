$:.unshift('lib')
require 'custom_attributes/version'

Gem::Specification.new do |s|
  s.name = 'custom_attributes'
  s.version = CustomAttributes::VERSION::STRING
  s.platform = Gem::Platform::RUBY
  s.summary = "CustomAttributes allows you to add custom attributes to ActiveRecord objects, optionally scoped by another model (e.g. users)."
  s.description = "CustomAttributes allows you to add custom attributes to ActiveRecord objects, optionally scoped by another model (e.g. users)."

  s.author = "René Föhring"
  s.email = 'rf@bamaru.de'
  s.homepage = "http://github.com/rrrene/custom_attributes"

  s.files = Dir[ 'lib/**/*', 'test/**/*']
  s.has_rdoc = false
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('rails', '~> 3')
end