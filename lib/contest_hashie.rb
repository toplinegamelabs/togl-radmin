class ContestHashie < Hashie::Dash
  property :contest_template
  property :is_invite_only
  property :user_contests_count

  def self.build_from_rapi_hash(hash)
    contest = self.new

    contest.contest_template = ContestTemplateHashie.build_from_rapi_hash(hash["contest_template"])
    contest.is_invite_only = hash["is_invite_only"]
    contest.user_contests_count = hash["user_contests_count"]

    contest
  end

  def is_invite_only?
    is_invite_only
  end
end
