require 'edata-system/services/transform_health_doc_service'

module EdataSystem
  module Patches
    module HealthRecordablePatch
      def self.included(base)
        base.class_eval do
          has_one :edata_migration_status, class_name: 'EdataSystem::EdataMigrationStatus', as: :migratable, dependent: :destroy

          after_create :create_migration_status

          alias_method :original_health_doc, :health_doc

          def health_doc
            if edata_migration_status&.health_doc_migrated
              EdataSystem.logger.info "Fetching health_doc from SQL for #{self.class.name} with ID #{id}"
              EdataSystem::Services::TransformHealthDocService.new(self).call
            else
              EdataSystem.logger.info "Fetching health_doc from Vault for #{self.class.name} with ID #{id}"
              original_health_doc
            end
          end

          private

          def create_migration_status
            create_migration_status!(health_doc_migrated: false)
          end
        end
      end
    end
  end
end
