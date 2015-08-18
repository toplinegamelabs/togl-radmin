namespace :contests do
  desc "Seeds needed empty contests"
  task :seed do => :environment
    require "#{Rails.root}/lib/contest_seeder"
    ContestSeeder.seed_needed_contests
  end
end
