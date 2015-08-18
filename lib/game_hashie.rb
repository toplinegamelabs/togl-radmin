class GameHashie < Hashie::Dash
  property :name
  property :id
  property :identifier
  property :state

  def self.build_from_rapi_hash(hash)
    game = self.new

    game.id = hash["id"]
    game.name = hash["name"]
    game.identifier = hash["identifier"]
    game.state = hash["state"]

    game
  end
end
