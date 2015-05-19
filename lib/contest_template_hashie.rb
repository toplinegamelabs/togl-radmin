class ContestTemplateHashie < Hashie::Dash
  property :id
  property :is_publicly_joinable, default: true
  property :game, default: GameHashie.new
  property :event_set, default: EventSetHashie.new
  property :buy_in, default: { "value" => 0 }
  property :size, default: { "value" => 2 }
  property :prize_table, default: []


  def self.build_from_rapi_hash(hash)
    template = self.new

    template.id = hash["id"]
    template.buy_in = hash["buy_in"]
    template.size = hash["size"]
    template.is_publicly_joinable = hash["is_publicly_joinable"]
    template.prize_table = hash["prize_table"]
    template
  end

  def is_publicly_joinable?
    is_publicly_joinable
  end
end
