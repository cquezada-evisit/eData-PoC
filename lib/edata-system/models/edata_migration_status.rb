module EdataSystem
  class EdataMigrationStatus < ActiveRecord::Base
    belongs_to :migratable, polymorphic: true
    belongs_to :edata_pack, class_name: 'EdataSystem::EdataPack', foreign_key: 'edata_pack_id', optional: true
  end
end
