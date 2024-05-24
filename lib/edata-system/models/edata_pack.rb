module EdataSystem
  class EdataPack < ActiveRecord::Base
    self.primary_key = 'id'
    has_many :edata_values, class_name: 'EdataSystem::EdataValue', foreign_key: 'edata_pack_id', dependent: :destroy

    before_create :generate_binary_uuid

    private

    def generate_binary_uuid
      self.id = SecureRandom.uuid.delete('-').scan(/../).map { |x| x.hex.chr }.join if id.nil?
    end
  end
end
