require 'rails/generators'

module EdataSystem
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_initializer_file
        template 'edata_system_initializer.rb.tt', 'config/initializers/edata_system.rb'
      end
    end
  end
end
