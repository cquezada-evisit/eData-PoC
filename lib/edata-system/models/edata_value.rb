module EdataSystem
  class EdataValue < ActiveRecord::Base
    self.primary_key = 'id'
    belongs_to :edata_pack, class_name: 'EdataSystem::EdataPack', foreign_key: 'edata_pack_id'
    belongs_to :edata_definition, class_name: 'EdataSystem::EdataDefinition', foreign_key: 'edata_definition_id'

    before_create :generate_binary_uuid

    private

    def generate_binary_uuid
      self.id = SecureRandom.uuid.delete('-').scan(/../).map { |x| x.hex.chr }.join if id.nil?
    end
  end
end
