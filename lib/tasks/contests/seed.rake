namespace :contests do
  desc "Seeds needed empty contests"
  task :seed => :environment do
    require "#{Rails.root}/lib/contest_seeder"
    ContestSeeder.seed_needed_contests
  end
end
