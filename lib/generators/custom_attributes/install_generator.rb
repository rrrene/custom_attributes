require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module CustomAttributes
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates (but does not run) a migration to add the custom_attributes table.'

    def copy_files
      template        'custom_attributes.rb', 'config/initializers/custom_attributes.rb'
    end
    
    def create_migration_file
      migration_template 'create_custom_attributes.rb', 'db/migrate/create_custom_attributes.rb'
    end
  end
end