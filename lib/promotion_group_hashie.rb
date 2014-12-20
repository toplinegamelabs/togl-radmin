class PromotionGroupHashie < Hashie::Dash
  property :id
  property :persisted, default: false
  property :identifier
  property :landing_page_id
  property :starts_at
  property :ends_at


  def persisted?
    persisted
  end


  def self.build_from_rapi_hash(hash)
    group = self.new
    group.id = hash["id"]
    group.identifier = hash["identifier"]
    group.landing_page_id = hash["landing_page_id"]
    group.starts_at = hash["starts_at"]
    group.ends_at = hash["ends_at"]
    group
  end
end
