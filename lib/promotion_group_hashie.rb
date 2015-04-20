class PromotionGroupHashie < Hashie::Dash
  property :id
  property :persisted, default: false
  property :identifier
  property :landing_page_id
  property :starts_at
  property :ends_at
  property :promotion_group_schedules, default: []

  def persisted?
    persisted
  end


  def self.build_from_rapi_hash(hash)
    Time.zone = "America/Los_Angeles"
    group = self.new
    group.id = hash["id"]
    group.identifier = hash["identifier"]
    group.landing_page_id = hash["landing_page_id"]
    group.starts_at = hash["starts_at"].to_s
    group.ends_at = hash["ends_at"].to_s
    group.promotion_group_schedules = hash["promotion_group_schedules"].collect { |pgs| PromotionGroupScheduleHashie.build_from_rapi_hash(pgs) }

    group
  end
end
