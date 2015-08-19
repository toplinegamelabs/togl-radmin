class ContestHashie < Hashie::Dash
  property :contest_template
  property :is_invite_only
  property :num_entries

  def self.build_from_rapi_hash(hash)
    contest = self.new

    contest.contest_template = ContestTemplateHashie.build_from_rapi_hash(hash["contest_template"])
    contest.is_invite_only = hash["is_invite_only"]
    contest.num_entries = hash["num_entries"]

    contest
  end

  def is_invite_only?
    is_invite_only
  end
end
