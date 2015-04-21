class PromotionGroupScheduleHashie < Hashie::Dash
  property :id
  property :opens_at
  property :starts_at
  property :date_tbd, default: false
  property :time_tbd, default: false
  property :league

  def self.build_from_rapi_hash(hash)
    schedule = self.new

    schedule.id = hash["id"]
    schedule.opens_at = hash["opens_at"]
    schedule.starts_at = hash["starts_at"]
    schedule.date_tbd = hash["starts_at_date_tbd"]
    schedule.time_tbd = hash["starts_at_time_tbd"]
    schedule.league = hash["league"]

    schedule
  end
end
