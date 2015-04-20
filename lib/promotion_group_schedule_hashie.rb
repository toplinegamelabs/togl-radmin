class PromotionGroupScheduleHashie < Hashie::Dash
  property :opens_at
  property :scheduled_at
  property :is_tbd, default: false
  property :league


  def self.build_from_rapi_hash(hash)
    schedule = self.new

    schedule.opens_at = hash["opens_at"]
    schedule.scheduled_at = hash["scheduled_at"]
    schedule.is_tbd = hash["is_tbd"]
    schedule.league = hash["league"]

    schedule
  end
end
