require "edata-system/version"
require "edata-system/ext/hash_extensions"

Dir[File.join(__dir__, 'edata-system/models', '*.rb')].each { |file| require file }

require "edata-system/services/transform_health_doc_service"
require "edata-system/patches/health_recordable_patch"

module EdataSystem
  class Error < StandardError; end

  def self.logger
    if defined?(Rails)
      Rails.logger
    else
      @logger ||= Logger.new(STDOUT)
    end
  end
end

# Cargar los generadores si Rails está definido
if defined?(Rails::Generators)
  require "edata-system/generators/edata/install_generator"
  require "edata-system/generators/edata/initializer/initializer_generator"
end

