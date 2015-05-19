class PromotionTargetHashie < Hashie::Dash
  property :persisted, default: false
  property :username
  property :max, default: 500
  property :contest_template, default: ContestTemplateHashie.new
  property :promotion, default: PromotionHashie.new
  property :entry, default: EntryHashie.new
  property :contest_type, default: "Contest"


  def persisted?
    persisted
  end


  def self.build_from_rapi_hash(hash)
    target = self.new

    target.username = hash["username"]
    target.max = hash["max"]
    target.contest_type = hash["contest_type"]
    target.contest_template = ContestTemplateHashie.build_from_rapi_hash(hash["contest_template"])
    target.contest_template.game = GameHashie.build_from_rapi_hash(hash["game"])
    target.contest_template.event_set = EventSetHashie.build_from_rapi_hash(hash["event_set"])
    target.promotion = PromotionHashie.build_from_rapi_hash(hash["promotion"])
    target.entry = EntryHashie.build_from_rapi_hash(hash["entry"])
    
    target
  end
end
