class ChallengeHashie < Hashie::Dash
  property :persisted, default: false
  property :username
  property :max, default: 500
  property :contest_template, default: ContestTemplateHashie.new
  property :promotion, default: PromotionHashie.new
  property :entry, default: EntryHashie.new


  def persisted?
    persisted
  end


  def self.build_from_rapi_hash(hash)
    challenge = self.new

    challenge.username = hash["username"]
    challenge.max = hash["max"]
    
    challenge.contest_template = ContestTemplateHashie.build_from_rapi_hash(hash["contest_template"])
    challenge.contest_template.game = GameHashie.build_from_rapi_hash(hash["game"])
    challenge.contest_template.event_set = EventSetHashie.build_from_rapi_hash(hash["event_set"])
    challenge.promotion = PromotionHashie.build_from_rapi_hash(hash["promotion"])
    challenge.entry = EntryHashie.build_from_rapi_hash(hash["entry"])

    challenge
  end
end
