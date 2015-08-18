class ContestTemplateHashie < Hashie::Dash
  property :id
  property :is_publicly_joinable, default: true
  property :game, default: GameHashie.new
  property :event_set, default: EventSetHashie.new
  property :buy_in, default: { "value" => 0 }
  property :size, default: { "value" => 2 }
  property :prize_table, default: []
  property :state
  property :lock_time
  property :is_publicly_creatable
  

  def self.build_from_rapi_hash(hash)
    template = self.new

    template.id = hash["id"]
    template.buy_in = hash["buy_in"]
    template.size = hash["size"]
    template.is_publicly_joinable = hash["is_publicly_joinable"]
    template.prize_table = hash.fetch("prize_table", {})["overall"]
    template.state = hash["state"]
    template.lock_time = Time.parse(hash["lock_time"])
    template.is_publicly_creatable = hash["is_publicly_creatable"]

    template
  end

  def is_publicly_joinable?
    is_publicly_joinable
  end

  def is_publicly_creatable?
    is_publicly_creatable
  end
end
