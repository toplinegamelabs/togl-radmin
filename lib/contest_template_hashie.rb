class ContestTemplateHashie < Hashie::Dash
  property :id
  property :is_publicly_joinable, default: true
  property :game, default: GameHashie.new
  property :event_set, default: EventSetHashie.new
  property :buy_in, default: {}
  property :size, default: {}


  def self.build_from_rapi_hash(hash)
    template = self.new

    template.id = hash["id"]
    template.buy_in = hash["size"]
    template.size = hash["buy_in"]
    template.is_publicly_joinable = hash["is_publicly_joinable"]

    template
  end

  def is_publicly_joinable?
    is_publicly_joinable
  end
end
