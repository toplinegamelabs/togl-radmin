class EventSetHashie < Hashie::Dash
  property :id
  property :description

  def self.build_from_rapi_hash(hash)
    set = self.new

    set.id = hash["id"]
    set.description = hash["description"]

    set
  end

end
