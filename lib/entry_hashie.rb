class EntryHashie < Hashie::Dash
  property :id
  property :entry_items, default: []


  def self.build_from_rapi_hash(hash)
    entry = self.new

    entry.id = hash["id"]
    entry.entry_items = hash["entry_items"].collect { |ei| EntryItemHashie.build_from_rapi_hash(ei) }

    entry
  end
end
