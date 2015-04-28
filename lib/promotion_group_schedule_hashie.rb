class PromotionGroupScheduleHashie < Hashie::Dash
  property :id
  property :opens_at
  property :starts_at
  property :starts_at_date_tbd, default: false
  property :starts_at_time_tbd, default: false
  property :opens_at_date_tbd, default: false
  property :opens_at_time_tbd, default: false
  property :league

  def self.build_from_rapi_hash(hash)
    schedule = self.new

    schedule.id = hash["id"]
    schedule.opens_at = hash["opens_at"]
    schedule.starts_at = hash["starts_at"]
    schedule.starts_at_date_tbd = hash["starts_at_date_tbd"]
    schedule.starts_at_time_tbd = hash["starts_at_time_tbd"]
    schedule.opens_at_date_tbd = hash["opens_at_date_tbd"]
    schedule.opens_at_time_tbd = hash["opens_at_time_tbd"]
    schedule.league = hash["league"]

    schedule
  end
end
