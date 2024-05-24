# lib/edata-system/generators/edata/install_generator.rb
require 'rails/generators'
require 'rails/generators/migration'

module EdataSystem
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      def create_migrations
        migration_template 'create_edata_migration_statuses.rb.tt', 'db/migrate/create_edata_migration_statuses.rb'
        sleep 1 # Ensuring unique timestamp

        migration_template 'create_edata_packs.rb.tt', 'db/migrate/create_edata_packs.rb'
        sleep 1 # Ensuring unique timestamp

        migration_template 'create_edata_definitions.rb.tt', 'db/migrate/create_edata_definitions.rb'
        sleep 1 # Ensuring unique timestamp

        migration_template 'create_edata_values.rb.tt', 'db/migrate/create_edata_values.rb'
        sleep 1 # Ensuring unique timestamp

        migration_template 'add_edata_pack_id_to_tables.rb.tt', 'db/migrate/add_edata_pack_id_to_tables.rb'
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          @prev_migration_nr ||= Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          @prev_migration_nr += 1
          @prev_migration_nr.to_s
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
