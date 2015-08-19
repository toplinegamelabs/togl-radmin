class ContestSeed < ActiveRecord::Base
  validates_presence_of :game_identifier
  validates_presence_of :size
  validates_presence_of :buy_in
  validates_presence_of :minutes_before_lock_cutoff

  validates_uniqueness_of :game_identifier, scope: [:size, :buy_in], message: "Game identifier, size, buy_in combination already exists"

  before_create :set_defaults, on: :create


  private

  def set_defaults
    self.minutes_before_lock_cutoff = 60 if self.minutes_before_lock_cutoff.nil?
    self.is_active = true if self.is_active.nil?
  end
end
