class EntryItemHashie < Hashie::Dash
  property :slot_id 
  property :event_participant_id



  def self.build_from_rapi_hash(hash)
    entry_item = self.new

    entry_item.slot_id = hash["slot_id"]
    entry_item.event_participant_id = hash["event_participant"]["id"]

    entry_item
  end
end
