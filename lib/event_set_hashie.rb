class EventSetHashie < Hashie::Dash
  property :id
  property :description
  property :contest_templates

  def self.build_from_rapi_hash(hash)
    set = self.new

    set.id = hash["id"]
    set.description = hash["description"]
    set.contest_templates = []
    if hash["contest_templates"]
      hash["contest_templates"].each do |contest_template|
        set.contest_templates << ContestTemplateHashie.build_from_rapi_hash(contest_template)
      end
    end

    set
  end

end
