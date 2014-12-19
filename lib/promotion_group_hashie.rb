class PromotionGroupHashie < Hashie::Dash
  property :persisted, default: false
  property :identifier
  property :landing_page_id


  def persisted?
    persisted
  end


  def self.build_from_rapi_hash(hash)
    group = self.new
    group.identifier = hash["identifier"]
    group.landing_page_id = hash["landing_page_id"]
    group
  end
end
