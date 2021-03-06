require "#{Rails.root}/lib/rapi_manager"
require "#{Rails.root}/lib/game_hashie"
require "#{Rails.root}/lib/event_set_hashie"
require "#{Rails.root}/lib/contest_template_hashie"
require "#{Rails.root}/lib/contest_hashie"
require "#{Rails.root}/app/models/contest_seed"

class ContestSeeder
  class << self
    def seed_needed_contests
      rapi_manager = RapiManager.new
      games = rapi_manager.list_games['games'].collect{|game| GameHashie.build_from_rapi_hash(game)}
      games.select{|game| game.state == 'active'}.each do |game|
        contest_seeds = ContestSeed.where(game_identifier: game.identifier, is_active: true).to_a
        next unless contest_seeds.count > 0
        rapi_manager.list_contest_templates(game.id)['event_sets'].collect{|event_set| EventSetHashie.build_from_rapi_hash(event_set)}.each do |event_set|
          open_contests = rapi_manager.list_open_contests(game.id, event_set.id)['contests'].collect{|contest| ContestHashie.build_from_rapi_hash(contest)}
          contest_seeds.each do |contest_seed|
            contest_template = event_set.contest_templates.select{|contest_template| contest_template.size['value'] == contest_seed.size &&
                                                                                     contest_template.buy_in['value'] == contest_seed.buy_in &&
                                                                                     contest_template.is_publicly_creatable? &&
                                                                                     contest_template.lock_time > Time.now + contest_seed.minutes_before_lock_cutoff.minutes}.first
            if contest_template && open_contests.select{|contest| contest.contest_template.id == contest_template.id &&
                                                                  contest.contest_type == 'Contest' &&
                                                                  contest.state == 'scheduled' &&
                                                                  contest.num_entries < contest_seed.size &&
                                                                  !contest.is_invite_only?}.count == 0
              rapi_manager.create_empty_contest(contest_template.id)
            end
          end
        end
      end
    end
  end
end
