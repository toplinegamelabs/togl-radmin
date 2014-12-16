class GameHashie < Hashie::Dash
  property :name
  property :id

  def self.build_from_rapi_hash(hash)
    game = self.new

    game.id = hash["id"]
    game.name = hash["name"]

    game
  end

end
