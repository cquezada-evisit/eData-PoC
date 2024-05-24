require 'securerandom'

module EdataSystem
  module Services
    class TransformHealthDocService
      def initialize(migratable)
        @migratable = migratable
        @migration_status = migratable.edata_migration_status || migratable.create_edata_migration_status!(health_doc_migrated: false)
      end

      def call
        begin
          Rails.logger.info "Health Doc migrated #{@migration_status.health_doc_migrated} for #{@migratable.class.name}: #{@migratable.id}"

          if @migration_status.health_doc_migrated
            fetch_from_sql
          else
            migrate_health_doc
            @migration_status.update(health_doc_migrated: true)
          end
        rescue StandardError => e
          Rails.logger.error "TransformHealthDocService Error: #{e}"
        end
      end

      private

      def migrate_health_doc
        edata_pack = create_edata_pack
        @migration_status.update(edata_pack_id: edata_pack.id)
        create_definitions_and_values(edata_pack.id)
      end

      def fetch_from_sql
        Rails.logger.info "SQL Health Doc"
        edata_pack = @migration_status.edata_pack

        # Recopilar todos los valores relacionados con el edata_pack
        values = EdataValue.where(edata_pack_id: edata_pack.id).includes(:edata_definition)

        # Construir el JSON a partir de los valores en SQL
        health_doc = { insurance: {}, phh: {}, meta: {} }

        values.each do |value|
          keys = value.edata_definition.name.split('_')
          nested_hash = keys.reverse.reduce(value.value) { |val, key| { key.to_sym => val } }
          health_doc.deep_merge!(nested_hash) { |_, old_val, new_val| old_val.is_a?(Hash) ? old_val.deep_merge(new_val) : new_val }
        end

        health_doc
      end

      def create_edata_pack
        Rails.logger.info "Creating EdataPack"

        begin
          EdataPack.create(id: binary_uuid)
        rescue StandardError => e
          Rails.logger.error "EdataPack Error: #{e}"
        end
      end

      def binary_uuid
        SecureRandom.uuid.delete('-').scan(/../).map { |x| x.hex.chr }.join
      end

      def create_definitions_and_values(edata_pack_id)
        _health_doc = @migratable.health_doc

        _health_doc.each do |key, value|
          process_nested_hash([key], value, edata_pack_id)
        end
      end

      def process_nested_hash(keys, value, edata_pack_id)
        if value.is_a?(Hash)
          value.each do |k, v|
            process_nested_hash(keys + [k], v, edata_pack_id)
          end
        else
          definition_name = keys.join('_')
          definition = EdataSystem::EdataDefinition.find_or_create_by(
            name: definition_name,
            data_type: determine_type(value),
            is_sensitive: false
          )

          create_edata_value(edata_pack_id, definition.id, value)
        end
      end

      def determine_type(value)
        case value
        when Integer
          'integer'
        when String
          'string'
        when TrueClass, FalseClass
          'boolean'
        when Float
          'float'
        when Date, Time
          'datetime'
        else
          'text'
        end
      end

      def create_edata_value(edata_pack_id, edata_definition_id, value)
        return if value.nil?

        begin
          EdataValue.create(
            id: binary_uuid,
            edata_pack_id: edata_pack_id,
            edata_definition_id: edata_definition_id,
            value: value,
            is_latest: true
          )
        rescue StandardError => e
          Rails.logger.error "EdataValue Error: #{e}"
        end
      end
    end
  end
end
