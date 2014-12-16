class EventSetHashie < Hashie::Dash
  property :description

  def self.build_from_rapi_hash(hash)
    set = self.new

    set.description = hash["description"]

    set
  end

end
