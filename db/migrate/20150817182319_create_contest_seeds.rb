class CreateContestSeeds < ActiveRecord::Migration
  def change
    create_table :contest_seeds do |t|
      t.string :game_identifier, null: false
      t.integer :size, null: false
      t.integer :buy_in, null: false
      t.integer :minutes_before_lock_cutoff, null: false, default: 60
      t.boolean :is_active, null: false, default: true
    end

    add_index :contest_seeds, [:game_identifier, :size, :buy_in], unique: true
  end
end
